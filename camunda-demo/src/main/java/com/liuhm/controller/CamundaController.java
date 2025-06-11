package com.liuhm.controller;

import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.HistoryService;
import org.camunda.bpm.engine.RuntimeService;
import org.camunda.bpm.engine.TaskService;
import org.camunda.bpm.engine.history.HistoricActivityInstance;
import org.camunda.bpm.engine.history.HistoricCaseInstanceQuery;
import org.camunda.bpm.engine.impl.persistence.entity.TaskEntity;
import org.camunda.bpm.engine.runtime.ProcessInstance;
import org.camunda.bpm.engine.task.Task;
import org.camunda.bpm.engine.task.TaskQuery;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/camunda")
@Slf4j
public class CamundaController {
    @Resource
    private RuntimeService runtimeService;
    @Resource
    private TaskService taskService;
    @Resource
    private HistoryService historyService;
    /**
     * 通过流程定义key，发起一个流程实例
     * @param processKey 流程定义key
     * @return 流程实例ID
     */
    @GetMapping(value = "/startProcessInstanceByKey/{processKey}/{businessKey}/{username}")
    public String startProcessInstanceByKey(@PathVariable("processKey") String processKey,@PathVariable("businessKey") String businessKey,@PathVariable("username") String username) {
        Map map = new HashMap();
        map.put("assignee", username);
        ProcessInstance instance = runtimeService.startProcessInstanceByKey(processKey,businessKey,map);
        map = new HashMap();
        map.put("assigneeList", Arrays.asList("admin", "admin2", "admin3"));
        TaskQuery taskQuery = taskService.createTaskQuery().processInstanceId(instance.getProcessInstanceId());
        taskService.complete(taskQuery.singleResult().getId(),map);
        return instance.getRootProcessInstanceId();
    }

    @PostMapping(value = "/complete/{taskId}")
    public Boolean complete(@PathVariable("taskId") String taskId,@RequestBody Map map) {
        taskService.complete(taskId,map);
        return true;
    }
    /**
     * 查询某个用户的待办任务
     * @param assignee 用户ID
     * @return 待办任务列表
     */
    @GetMapping(value = "/getTaskByAssignee/{assignee}")
    public List<TaskEntity> getTaskByAssignee(@PathVariable("assignee") String assignee) {
        List<TaskEntity> taskList = (List)taskService.createTaskQuery().taskAssignee(assignee).list();
        for (Task task : taskList) {
            String taskTitle = "待办任务ID="+task.getId()+",流程实例ID="+task.getProcessInstanceId()+"\n";
            log.info(taskTitle);
        }
        return taskList;
    }

    /**
     * 获取历史记录
     * @return 待办任务列表
     */
    @GetMapping(value = "/getHistoryByProcessInstanceId/{processInstanceId}")
    public List<HistoricActivityInstance> getHistoryByProcessInstanceId(@PathVariable("processInstanceId") String processInstanceId) {
        // 获取流程实例的所有历史活动实例
        List<HistoricActivityInstance> historicActivityInstances = historyService.createHistoricActivityInstanceQuery()
                .processInstanceId(processInstanceId)
                .orderByHistoricActivityInstanceStartTime()
                .asc()
                .list();

        // 输出每个历史活动实例的信息
        for (HistoricActivityInstance hai : historicActivityInstances) {
            log.info("-----------------------------" );
            log.info("活动实例ID: " + hai.getId());
            log.info("活动ID: " + hai.getActivityId());
            log.info("开始时间: " + hai.getStartTime());
            log.info("结束时间: " + hai.getEndTime());
            log.info("执行者: " + hai.getAssignee());
        }
        return historicActivityInstances;
    }
}