package com.liuhm.service;


import com.liuhm.tenant.context.TenantContextHolder;
import com.liuhm.vo.BpmTaskDonePageReqVO;
import com.liuhm.vo.BpmTaskPageReqVO;
import com.liuhm.vo.CamTaskVO;
import com.liuhm.vo.IPage;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.*;
import org.camunda.bpm.engine.history.HistoricActivityInstance;
import org.camunda.bpm.engine.history.HistoricProcessInstance;
import org.camunda.bpm.engine.history.HistoricTaskInstance;
import org.camunda.bpm.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.camunda.bpm.engine.impl.interceptor.Command;
import org.camunda.bpm.engine.impl.interceptor.CommandContext;
import org.camunda.bpm.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.camunda.bpm.engine.impl.persistence.entity.TaskEntity;
import org.camunda.bpm.engine.impl.persistence.entity.VariableInstanceEntity;
import org.camunda.bpm.engine.repository.Deployment;
import org.camunda.bpm.engine.repository.ProcessDefinition;
import org.camunda.bpm.engine.runtime.VariableInstance;
import org.camunda.bpm.model.xml.ModelInstance;
import org.camunda.bpm.model.xml.instance.ModelElementInstance;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.testng.annotations.Test;

import javax.annotation.Resource;
import java.util.*;

@Slf4j
@SpringBootTest
public class CamundaTaskServiceTest extends AbstractTestNGSpringContextTests {

    @Resource
    private CamundaTaskService camundaTaskService;

    @Resource
    private HistoryService historyService;
    @Resource
    private RuntimeService runtimeService;
    @Resource
    private RepositoryService repositoryService;
//    private final static String tenantId = "master";
    private final static String tenantId = "dm";
    @Test
    public void deployment() {
        TenantContextHolder.setTenantId(tenantId);
        repositoryService.createDeployment()
                .addClasspathResource("regularApproval.bpmn")
                .name("常规审批")
                .deploy();
        // 拒绝没有回退
        repositoryService.createDeployment()
                .addClasspathResource("regularApproval2.bpmn")
                .name("常规审批2")
                .deploy();
        repositoryService.createDeployment()
                .addClasspathResource("gradualApproval.bpmn")
                .name("逐级审批")
                .deploy();
    }
    @Test
    public void ttt() {
        TenantContextHolder.setTenantId(tenantId);
        // 获取流程定义
        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionKey("gradualApproval")
                .orderByDeploymentTime().desc().list().get(0);

        // 获取所有变量实例
        List<VariableInstance> variableInstances = runtimeService.createVariableInstanceQuery()
                .processInstanceIdIn(processDefinition.getId()).list();

        // 遍历并打印变量名
        for (VariableInstance variableInstance : variableInstances) {
            System.out.println("Variable Name: " + variableInstance.getName());
        }

        // 获取流程定义的所有变量
        ProcessDefinitionEntity processDefinitionEntity = (ProcessDefinitionEntity) processDefinition;

        // 打印变量
            System.out.println("Variable Name: ");
    }
    @Test
    public void deleteProcessDefinition() {
        TenantContextHolder.setTenantId(tenantId);

        List<ProcessDefinition> processDefinitionList = repositoryService.createProcessDefinitionQuery().processDefinitionKey("gradualApproval").list();
        for (ProcessDefinition processDefinition : processDefinitionList) {
            repositoryService.deleteProcessDefinition(processDefinition.getId());
            repositoryService.deleteDeployment(processDefinition.getDeploymentId());
        }

    }
    @Test
    public void test() {
        TenantContextHolder.setTenantId(tenantId);

//        numberApprovals
        String username = "lisi";
        BpmTaskPageReqVO bpmTaskTodoPageReqVO = new BpmTaskPageReqVO();
        bpmTaskTodoPageReqVO.setSize(10);
        bpmTaskTodoPageReqVO.setPage(1);
        IPage<CamTaskVO> myProcessInstancePage = camundaTaskService.getMyProcessInstancePage(username, bpmTaskTodoPageReqVO);
        System.out.println(myProcessInstancePage);
        List<CamTaskVO> list = camundaTaskService.getProcessInstanceDetail(myProcessInstancePage.getRecords().get(0).getProcessInstanceId());
        System.out.println(list);
    }
    @Test
    public void regularApprovalTest() {
        TenantContextHolder.setTenantId(tenantId);

//        numberApprovals
        String username = "lisi";
        List<String> oneAssigneeList = Arrays.asList("zhangsan");
        List<String> assigneeList = Arrays.asList("zhangsan","wangwu","wangmazi");
        // 一个节点
        // 或签 1个人同意

        // 一个审批人  同意
        // 开启任务
        Map map = new HashMap();
        map.put("numberApprovals",1);
        String uuid ;
        String processInstanceId ;
       /* uuid = UUID.randomUUID().toString();
         processInstanceId = camundaTaskService.startProcessInstanceByKey("regularApproval", uuid, username,map,oneAssigneeList);
        // 查询任务
        for (String s : oneAssigneeList) {
            BpmTaskPageReqVO bpmTaskTodoPageReqVO = new BpmTaskPageReqVO();
            bpmTaskTodoPageReqVO.setSize(10);
            bpmTaskTodoPageReqVO.setPage(1);
            IPage<CamTaskVO> todoTaskPage = camundaTaskService.getTodoTaskPage(s, bpmTaskTodoPageReqVO);
            System.out.println(todoTaskPage.getTotal());
            camundaTaskService.approveTask(s,todoTaskPage.getRecords().get(0).getTaskId(),"同意",null);

            todoTaskPage = camundaTaskService.getTodoTaskPage(s, bpmTaskTodoPageReqVO);
            System.out.println(todoTaskPage.getTotal());
        }*/
        // 一个审批人  不同意
       uuid = UUID.randomUUID().toString();
        processInstanceId = camundaTaskService.startProcessInstanceByKey("regularApproval", uuid, username,map,oneAssigneeList);
        // 查询任务
        for (String s : oneAssigneeList) {
            BpmTaskPageReqVO bpmTaskTodoPageReqVO = new BpmTaskPageReqVO();
            bpmTaskTodoPageReqVO.setSize(10);
            bpmTaskTodoPageReqVO.setPage(1);
            IPage<CamTaskVO> todoTaskPage = camundaTaskService.getTodoTaskPage(s, bpmTaskTodoPageReqVO);
            System.out.println(todoTaskPage.getTotal());
            camundaTaskService.rejectTask(s,todoTaskPage.getRecords().get(0).getTaskId(),"不同意",null);

            todoTaskPage = camundaTaskService.getTodoTaskPage(s, bpmTaskTodoPageReqVO);
            System.out.println(todoTaskPage.getTotal());
            todoTaskPage = camundaTaskService.getTodoTaskPage(username, bpmTaskTodoPageReqVO);
            System.out.println(todoTaskPage.getTotal());
        }

        // 一个审批人  停止任务
      /*  uuid = UUID.randomUUID().toString();
        processInstanceId = camundaTaskService.startProcessInstanceByKey("regularApproval", uuid, username,map,oneAssigneeList);
        // 查询任务
        for (String s : oneAssigneeList) {
            BpmTaskPageReqVO bpmTaskPageReqVO = new BpmTaskPageReqVO();
            bpmTaskPageReqVO.setSize(10);
            bpmTaskPageReqVO.setPage(1);
            IPage<CamTaskVO> todoTaskPage = camundaTaskService.getTodoTaskPage(s, bpmTaskPageReqVO);
            System.out.println(todoTaskPage.getTotal());
            camundaTaskService.stopTask(s,todoTaskPage.getRecords().get(0).getTaskId(),"不同意");

            todoTaskPage = camundaTaskService.getTodoTaskPage(s, bpmTaskPageReqVO);
            System.out.println(todoTaskPage.getTotal());


            BpmTaskPageReqVO bpmTaskDonePageReqVO = new BpmTaskPageReqVO();
            bpmTaskDonePageReqVO.setSize(10);
            bpmTaskDonePageReqVO.setPage(1);
            IPage<CamTaskVO> doneTaskPage = camundaTaskService.getDoneTaskPage(username, bpmTaskDonePageReqVO);
            System.out.println(doneTaskPage.getTotal());
        }*/



        // 会签 所有人同意
    }
}