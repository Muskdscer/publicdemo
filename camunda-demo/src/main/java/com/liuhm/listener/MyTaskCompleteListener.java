package com.liuhm.listener;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.DelegateTask;
import org.camunda.bpm.engine.impl.core.model.CoreModelElement;
import org.camunda.bpm.engine.impl.history.event.HistoryEvent;
import org.camunda.bpm.engine.impl.persistence.entity.ExecutionEntity;
import org.camunda.bpm.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.camunda.bpm.engine.impl.pvm.process.ActivityImpl;
import org.camunda.bpm.model.bpmn.instance.*;
import org.camunda.bpm.spring.boot.starter.event.ExecutionEvent;
import org.camunda.bpm.spring.boot.starter.event.TaskEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;


/**
 * @ClassName：MyTaskCompleteListener
 * @Description: 任务监听
 * @Author: liuhaomin
 * @Date: 2024/12/3 13:52
 */
@Slf4j
@Component
public class MyTaskCompleteListener {
    // Spring 事件总线
//    http://camunda-cn.shaochenfeng.com/user-guide/spring-boot-integration/the-spring-event-bridge/
//    @EventListener
    public void onTaskEvent(DelegateTask delegateTask) {
        // 获取任务相关的业务数据
        String taskId = delegateTask.getId();
        String processInstanceId = delegateTask.getProcessInstanceId();
        String processDefinitionId = delegateTask.getProcessDefinitionId();
        String assignee = delegateTask.getAssignee();
        log.info("processDefinitionId {}, processInstanceId {} , taskId {} , assignee {}",processDefinitionId,processInstanceId,taskId,assignee);
        // 执行自定义的业务逻辑，例如通知相关人员任务已经完成
        // 实现TaskListener中的方法
        String eventName = delegateTask.getEventName();
        if ("create".endsWith(eventName)) {
            log.info("create=========");
        } else if ("assignment".endsWith(eventName)) {
            log.info("assignment========");
        } else if ("complete".endsWith(eventName)) {
            log.info("complete===========");
        } else if ("delete".endsWith(eventName)) {
            log.info("delete=============");
        }
        // 处理可变的任务事件
    }

//    @EventListener
    public void onTaskEvent(TaskEvent taskEvent) {
        // 处理不可变的任务事件
        // 执行自定义的业务逻辑，例如通知相关人员任务已经完成
        // 实现TaskListener中的方法
        String eventName = taskEvent.getEventName();
        if ("create".endsWith(eventName)) {
            log.info("create=========");
        } else if ("assignment".endsWith(eventName)) {
            log.info("assignment========");
        } else if ("complete".endsWith(eventName)) {
            log.info("complete===========");
        } else if ("delete".endsWith(eventName)) {
            log.info("delete=============");
        }
    }

    /**
     * 监听任务开始结束
     * @param executionDelegate
     */
    @EventListener
    public void onExecutionEvent(DelegateExecution executionDelegate) {
        // 处理可变的执行事件
        String eventName = executionDelegate.getEventName();
//        log.info(eventName+ " " +executionDelegate.getCurrentActivityName() );
        if(!("end".endsWith(eventName))){
            return;
        }
        log.info("processBusinessKey {} ",executionDelegate.getProcessBusinessKey());
        String processDefinitionId = executionDelegate.getProcessDefinitionId();
        FlowElement bpmnModelElementInstance = executionDelegate.getBpmnModelElementInstance();
        CoreModelElement eventSource = ((ExecutionEntity) executionDelegate).getEventSource();
        if(bpmnModelElementInstance instanceof UserTask){
            UserTask userTask =(UserTask)bpmnModelElementInstance;
            LoopCharacteristics loopCharacteristics = userTask.getLoopCharacteristics();
            if(loopCharacteristics==null){

            }
            log.info("processDefinitionId {} ,UserTask {}",processDefinitionId,executionDelegate.getCurrentActivityName());
        }
        else if(bpmnModelElementInstance instanceof StartEvent){
            log.info("processDefinitionId {} ,开始了任务",processDefinitionId);
        }
        else if(bpmnModelElementInstance instanceof EndEvent && eventSource instanceof ActivityImpl) {

            // 正常结束
           log.info("processDefinitionId {} ,正常结束",processDefinitionId);
        }


        if(eventSource instanceof ProcessDefinitionEntity){
            // 流程结束  正常结束，终止结束都是
            Object reject = executionDelegate.getVariable("reject");
            log.info("processDefinitionId {} ,流程结束 1 拒绝 0 同意 null 终止 reject {}",processDefinitionId,reject);

        }
       /* if ("create".endsWith(eventName)) {
            log.info("create=========");
        } else if ("assignment".endsWith(eventName)) {
            log.info("assignment========");
        } else if ("complete".endsWith(eventName)) {
            log.info("complete===========");
        } else if ("delete".endsWith(eventName)) {
            log.info("delete=============");
        }*/
    }

//    @EventListener
    public void onExecutionEvent(ExecutionEvent executionEvent) {
        // 处理不可改的执行事件
        log.info("create========="+ executionEvent.getEventName());
    }

//    @EventListener
    public void onHistoryEvent(HistoryEvent historyEvent) {
        // 处理历史事件
        log.info("create========="+ historyEvent.getEventType());
    }

}