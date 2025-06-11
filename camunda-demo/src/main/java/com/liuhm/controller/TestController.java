package com.liuhm.controller;
import org.camunda.bpm.engine.RuntimeService;
import org.camunda.bpm.engine.TaskService;
import org.camunda.bpm.engine.impl.persistence.entity.TaskEntity;
import org.camunda.bpm.engine.runtime.ProcessInstance;
import org.camunda.bpm.engine.task.Task;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping
public class TestController {
    @Resource
    private RuntimeService runtimeService;
    @Resource
    private TaskService taskService;
    /**
     * 通过流程定义key，发起一个流程实例
     * @param processKey 流程定义key
     * @return 流程实例ID
     */
    @GetMapping(value = "/startProcessInstanceByKey/{processKey}")
    public String startProcessInstanceByKey(@PathVariable("processKey") String processKey) {
        ProcessInstance instance = runtimeService.startProcessInstanceByKey(processKey);
        return instance.getRootProcessInstanceId();
    }

    /**
     * 查询某个用户的待办任务
     * @param assignee 用户ID
     * @return 待办任务列表
     */
    @GetMapping(value = "/getTaskByAssignee/{assignee}")
    public String getTaskByAssignee(@PathVariable("assignee") String assignee) {
        List<TaskEntity> taskList = (List)taskService.createTaskQuery().taskAssignee(assignee).list();
        StringBuffer sb = new StringBuffer();
        for (Task task : taskList) {
            String taskTitle = "待办任务ID="+task.getId()+",流程实例ID="+task.getProcessInstanceId()+"\n";
            System.out.println(taskTitle);
            sb.append(taskTitle);
        }
        return sb.toString();
    }
}