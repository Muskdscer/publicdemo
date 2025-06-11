package com.liuhm.controller;


import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.HistoryService;
import org.camunda.bpm.engine.RepositoryService;
import org.camunda.bpm.engine.history.HistoricVariableInstance;
import org.camunda.bpm.engine.impl.persistence.entity.TaskEntity;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.testng.annotations.Test;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@SpringBootTest
public class CamundaControllerTest extends AbstractTestNGSpringContextTests {

    @Resource
    private CamundaController camundaController;

    @Resource
    private HistoryService historyService;
    @Resource
    private RepositoryService repositoryService;

    @Test
    public void deployment() {
        repositoryService.createDeployment()
                .addClasspathResource("regularApproval.bpmn")
                .name("常规审批")
                .deploy();
        repositoryService.createDeployment()
                .addClasspathResource("gradualApproval.bpmn")
                .name("逐级审批")
                .deploy();
    }

    @Test
    public void test() {

        String processInstanceId = camundaController.startProcessInstanceByKey("regularApproval", "第一次测试", "zhangsan2");
        List<TaskEntity> taskEntityList = camundaController.getTaskByAssignee("admin");

        Map map = new HashMap<>();
        map.put("withVariablesInReturn",true);
        map.put("variable",new HashMap<>().put("value","china"));
        map.put("variable2",new HashMap<>().put("value",false));
        camundaController.complete(taskEntityList.get(0).getId(),map);

        camundaController.getHistoryByProcessInstanceId(processInstanceId);
        List<HistoricVariableInstance> historicVariables = historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(processInstanceId)
                .orderByVariableName().desc()
                .list();
        log.info("1");
    }
    @Test
    public void complete() {

        List<TaskEntity> taskEntityList = camundaController.getTaskByAssignee("admin2");


        camundaController.complete(taskEntityList.get(0).getId(),new HashMap<>());

       taskEntityList = camundaController.getTaskByAssignee("admin3");


        camundaController.complete(taskEntityList.get(0).getId(),new HashMap<>());

    }


    /**
     * 通过流程定义key，发起一个流程实例
     * @return 流程实例ID
     */
    @Test
    public void startProcessInstanceByKey() {
        String processInstanceId = camundaController.startProcessInstanceByKey("huiqiantest", "第一次测试", "zhangsan2");

    }

    @Test
    public void getTaskByAssignee() {
        String admin = String.valueOf(camundaController.getTaskByAssignee("admin"));
        log.info(admin);
        String admin2 = String.valueOf(camundaController.getTaskByAssignee("admin2"));
        log.info(admin2);
        String admin3 = String.valueOf(camundaController.getTaskByAssignee("admin3"));
        log.info(admin3);
    }

    @Test
    public void getHistoryByProcessInstanceId() {
        camundaController.getHistoryByProcessInstanceId("25e154c5-ac75-11ef-9fa6-0a0027000009");
    }


}