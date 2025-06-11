package com.liuhm.service.impl;

import com.liuhm.dto.PageBaseDTO;
import com.liuhm.service.CamundaTaskService;
import com.liuhm.tenant.context.TenantContextHolder;
import com.liuhm.vo.BpmTaskDonePageReqVO;
import com.liuhm.vo.BpmTaskPageReqVO;
import com.liuhm.vo.CamTaskVO;
import com.liuhm.vo.IPage;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.camunda.bpm.engine.HistoryService;
import org.camunda.bpm.engine.IdentityService;
import org.camunda.bpm.engine.RuntimeService;
import org.camunda.bpm.engine.TaskService;
import org.camunda.bpm.engine.history.*;
import org.camunda.bpm.engine.impl.persistence.entity.TaskEntity;
import org.camunda.bpm.engine.runtime.ProcessInstance;
import org.camunda.bpm.engine.task.Comment;
import org.camunda.bpm.engine.task.Task;
import org.camunda.bpm.engine.task.TaskQuery;
import org.springframework.beans.BeanUtils;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.groupingBy;
import static java.util.stream.Collectors.toMap;

/**
 * @ClassName：BpmTaskServiceImpl
 * @Description: 流程任务实例 Service 实现类
 * @Author: liuhaomin
 * @Date: 2024/11/28 10:50
 */
@Slf4j
@Service
public class CamundaTaskServiceImpl implements CamundaTaskService {

    private final static String ASSIGNEE = "assignee";
    private final static String ASSIGNEE_LIST = "assigneeList";
    private final static String REASON = "reason";
    private final static String APPROVE = "approve";

    @Resource
    private TaskService taskService;
    @Resource
    private HistoryService historyService;
    @Resource
    private RuntimeService runtimeService;
    @Resource
    private IdentityService identityService;

    @Override
    public String startProcessInstanceByKey(String processKey, String businessKey, String username, Map map, List<String> assigneeList) {
        //设置发起人
        identityService.setAuthenticatedUserId(username);
        Map map2 = new HashMap();
        map2.put(ASSIGNEE, username);
        businessKey = TenantContextHolder.getTenantId() + ":" + businessKey;
        ProcessInstance instance = runtimeService.startProcessInstanceByKey(processKey,businessKey,map2);
        if(Objects.isNull(map)){
            map = new HashMap();
        }
        map.put(ASSIGNEE_LIST, assigneeList);
        TaskQuery taskQuery = taskService.createTaskQuery().processInstanceId(instance.getProcessInstanceId());
        taskService.complete(taskQuery.singleResult().getId(),map);
        return instance.getRootProcessInstanceId();
    }

    @Override
    public void approveTask(String username, String taskId, String reason, Map map) {
        // 校验任务存在
        Task task = checkTask(username, taskId);
        // 校验流程实例存在
        ProcessInstance instance =  runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult();
        if (instance == null) {
            throw new RuntimeException("该任务流程实例不存在");
        }
        if(Objects.isNull(map)){
            map = new HashMap();
        }
        map.put(APPROVE,1);
        // 完成任务，审批通过
        taskService.complete(taskId,map);
        taskService.createComment(taskId,instance.getProcessInstanceId(),reason);
    }

    @Override
    public void rejectTask(String username, String taskId, String reason, Map map) {
        // 校验任务存在
        Task task = checkTask(username, taskId);
        // 校验流程实例存在
        ProcessInstance instance =  runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult();
        if (instance == null) {
            throw new RuntimeException("该任务流程实例不存在");
        }
        if(Objects.isNull(map)){
            map = new HashMap();
        }
        map.put(APPROVE,0);
        // 完成任务，审批不通过
        taskService.complete(task.getId(),map);
        taskService.createComment(taskId,instance.getProcessInstanceId(),reason);
    }

    @Override
    public void stopTask(String username, String taskId, String reason) {
        // 校验任务存在
        Task task = checkTask(username, taskId);
        // 校验流程实例存在
        ProcessInstance instance =  runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult();
        if (instance == null) {
            throw new RuntimeException("该任务流程实例不存在");
        }
        // 删除流程实例，以实现驳回任务时，取消整个审批流程
        runtimeService.deleteProcessInstance(instance.getProcessInstanceId(), String.format("不通过任务，原因：%s",reason));
        taskService.createComment(taskId,instance.getProcessInstanceId(),reason);
    }

    @Override
    public void cancelProcessInstance(String username, String processInstanceId, String reason) {
        // 校验流程实例存在
        HistoricProcessInstance instance = getHistoricProcessInstance(processInstanceId);
        if (instance == null) {
            throw new RuntimeException("该任务流程实例不存在");
        }
        // 只能取消自己的
        if (!Objects.equals(instance.getStartUserId(), String.valueOf(username))) {
            throw new RuntimeException("流程取消失败，该流程不是你发起的");
        }
        // 通过删除流程实例，实现流程实例的取消,
        // 删除流程实例，以实现驳回任务时，取消整个审批流程
        runtimeService.deleteProcessInstance(processInstanceId, String.format("主动取消任务，原因：%s",reason));
    }


    @Override
    public  List<CamTaskVO> getTodoTaskList(String username) {
        return (List)taskService.createTaskQuery().taskAssignee(username).list();
    }

    @Override
    public List<CamTaskVO> getProcessInstanceDetail(String processInstanceId) {
        List<CamTaskVO> list = historyService.createHistoricTaskInstanceQuery().processInstanceId(processInstanceId)
                .orderByHistoricActivityInstanceStartTime().asc().list().stream()
                .map(d->{
                    CamTaskVO camTaskVO = new CamTaskVO();
                    BeanUtils.copyProperties(d,camTaskVO);
                    camTaskVO.setProcessDefinitionId(d.getProcessDefinitionId());
                    camTaskVO.setTaskDefinitionKey(d.getProcessDefinitionKey());
                    camTaskVO.setProcessInstanceId(d.getRootProcessInstanceId());
                    camTaskVO.setTaskDefinitionKey(d.getTaskDefinitionKey());
                    camTaskVO.setName(d.getName());
                    camTaskVO.setAssignee(d.getAssignee());
                    camTaskVO.setStartTime(d.getStartTime());
                    camTaskVO.setEndTime(d.getEndTime());
                    camTaskVO.setTaskId(d.getId());
                    camTaskVO.setDurationInMillis(d.getDurationInMillis());
                    camTaskVO.setDeleteReason(d.getDeleteReason());
                    camTaskVO.setTenantId(d.getTenantId());
                    List<Comment> taskComments = taskService.getTaskComments(camTaskVO.getTaskId());
                    if(!CollectionUtils.isEmpty(taskComments)){
                        camTaskVO.setReason(taskComments.stream().map(Comment::getFullMessage).collect(Collectors.joining(",")));
                    }
                    return camTaskVO;
                }).collect(Collectors.toList());

        return list;
    }

    @Override
    public IPage<CamTaskVO> getMyProcessInstancePage(String username, BpmTaskPageReqVO pageVO) {
        // 查询待办任务
        // 分配给自己
        // 创建时间倒序
        HistoricProcessInstanceQuery query = historyService.createHistoricProcessInstanceQuery().startedBy(username)
                .orderByProcessInstanceStartTime().desc();
        if (StringUtils.isNotBlank(pageVO.getName())) {
            query.processInstanceBusinessKey("%" + pageVO.getName() + "%");
        }
        if (pageVO.getBeginCreateTime()!= null) {
            query.startedAfter(pageVO.getBeginCreateTime());
        }
        if (pageVO.getBeginEndTime()!= null) {
            query.startedBefore(pageVO.getBeginEndTime());
        }

        long count = query.count();
        if (count == 0) {
            return new IPage<>(new ArrayList<>(),0);
        }

        // 执行查询
        List<CamTaskVO> tasks = query.listPage(getStart(pageVO), pageVO.getSize()).stream()
                .map(d->{
                    CamTaskVO camTaskVO = new CamTaskVO();
                    BeanUtils.copyProperties(d,camTaskVO);
                    camTaskVO.setProcessDefinitionId(d.getProcessDefinitionId());
                    camTaskVO.setProcessDefinitionKey(d.getProcessDefinitionKey());
                    camTaskVO.setProcessInstanceId(d.getRootProcessInstanceId());
                    camTaskVO.setTaskDefinitionKey(d.getStartActivityId());
                    camTaskVO.setAssignee(d.getStartUserId());
                    camTaskVO.setStartTime(d.getStartTime());
                    camTaskVO.setEndTime(d.getEndTime());
                    return camTaskVO;
                }).collect(Collectors.toList());

        return new IPage<>(tasks,count);
    }

    @Override
    public IPage<CamTaskVO> getTodoTaskPage(String username, BpmTaskPageReqVO pageVO) {
        // 查询待办任务
        // 分配给自己
        // 创建时间倒序
        TaskQuery taskQuery = taskService.createTaskQuery().taskAssignee(username)
                .orderByTaskCreateTime().desc();
        if (StringUtils.isNotBlank(pageVO.getName())) {
            taskQuery.taskNameLike("%" + pageVO.getName() + "%");
        }
        if (pageVO.getBeginCreateTime()!= null) {
            taskQuery.taskCreatedAfter(pageVO.getBeginCreateTime());
        }
        if (pageVO.getEndCreateTime()!= null) {
            taskQuery.taskCreatedBefore(pageVO.getEndCreateTime());
        }
        // 执行查询
        List<CamTaskVO> tasks = taskQuery.listPage(getStart(pageVO), pageVO.getSize()).stream()
                .map(d->{
            CamTaskVO camTaskVO = new CamTaskVO();
            BeanUtils.copyProperties(d,camTaskVO);
            camTaskVO.setProcessDefinitionId(d.getProcessDefinitionId());
            camTaskVO.setProcessInstanceId(d.getProcessInstanceId());
            camTaskVO.setTaskDefinitionKey(d.getTaskDefinitionKey());
            camTaskVO.setAssignee(d.getAssignee());
            camTaskVO.setStartTime(d.getCreateTime());
            camTaskVO.setTaskId(d.getId());
            return camTaskVO;
        }).collect(Collectors.toList());


        if (CollectionUtils.isEmpty(tasks)) {
            return new IPage<>(new ArrayList<>(),0);
        }
        long count = taskQuery.count();

        return new IPage<>(tasks,count);
    }

    @Override
    public IPage<CamTaskVO> getDoneTaskPage(String username, BpmTaskPageReqVO pageVO) {
        // 查询已办任务
        // 已完成 // 分配给自己 // 审批时间倒序
        HistoricTaskInstanceQuery taskQuery = historyService.createHistoricTaskInstanceQuery().finished()
                .taskAssignee(username)
                .orderByHistoricTaskInstanceEndTime().desc();
        if (StringUtils.isNotBlank(pageVO.getName())) {
            taskQuery.taskNameLike("%" + pageVO.getName() + "%");
        }
        if (pageVO.getBeginCreateTime() != null) {
            taskQuery.finishedAfter(pageVO.getBeginCreateTime());
        }
        if (pageVO.getEndCreateTime() != null) {
            taskQuery.finishedBefore(pageVO.getEndCreateTime());
        }
        // 执行查询
        List<CamTaskVO> tasks = taskQuery.listPage(getStart(pageVO), pageVO.getSize()).stream()
                .map(d->{
                    CamTaskVO camTaskVO = new CamTaskVO();
                    BeanUtils.copyProperties(d,camTaskVO);
                    camTaskVO.setProcessDefinitionId(d.getProcessDefinitionId());
                    camTaskVO.setProcessInstanceId(d.getProcessInstanceId());
                    camTaskVO.setTaskDefinitionKey(d.getTaskDefinitionKey());
                    camTaskVO.setProcessDefinitionKey(d.getProcessDefinitionKey());
                    camTaskVO.setDeleteReason(d.getDeleteReason());
                    camTaskVO.setTenantId(d.getTenantId());
                    camTaskVO.setDurationInMillis(d.getDurationInMillis());
                    camTaskVO.setAssignee(d.getAssignee());
                    camTaskVO.setStartTime(d.getStartTime());
                    camTaskVO.setEndTime(d.getEndTime());
                    return camTaskVO;
                }).collect(Collectors.toList());
        if (CollectionUtils.isEmpty(tasks)) {
            return new IPage<>(new ArrayList<>(),0);
        }
        long count = taskQuery.count();

        return new IPage<>(tasks,count);

    }

    public HistoricProcessInstance getHistoricProcessInstance(String id) {
        return historyService.createHistoricProcessInstanceQuery().processInstanceId(id).singleResult();
    }

    public static int getStart(PageBaseDTO pageBaseDTO) {
        return (pageBaseDTO.getPage() - 1) * pageBaseDTO.getSize();
    }

    /**
     * 校验任务是否存在， 并且是否是分配给自己的任务
     *
     * @param username 用户
     * @param taskId task id
     */
    private Task checkTask(String username, String taskId) {
        Task task = getTask(taskId);
        if (task == null) {
            throw new RuntimeException("该任务不存在");
        }
        if (!Objects.equals(username, task.getAssignee())) {
            throw new RuntimeException("该任务的审批人不是你");
        }
        return task;
    }
    private Task getTask(String taskId) {
        return taskService.createTaskQuery().taskId(taskId).singleResult();
    }

}
