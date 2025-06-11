package com.liuhm.service;


import com.liuhm.vo.BpmTaskDonePageReqVO;
import com.liuhm.vo.BpmTaskPageReqVO;
import com.liuhm.vo.CamTaskVO;
import com.liuhm.vo.IPage;
import org.camunda.bpm.engine.history.HistoricProcessInstance;
import org.camunda.bpm.engine.impl.persistence.entity.TaskEntity;

import java.util.List;
import java.util.Map;

/**
 * @ClassName：BpmTaskService
 * @Description: 流程任务实例 Service 接口
 * @Author: liuhaomin
 * @Date: 2024/11/28 10:50
 */
public interface CamundaTaskService {
 /**
  * 获取待办任务
  * @param username
  * @return
  */
 List<CamTaskVO> getTodoTaskList(String username);
 /**
  * 获得待办的流程任务分页
  *
  * @param username    用户编号
  * @param pageVO 分页请求
  *
  * @return 流程任务分页
  */
 IPage<CamTaskVO> getTodoTaskPage(String username, BpmTaskPageReqVO pageVO);

 IPage<CamTaskVO> getMyProcessInstancePage(String username, BpmTaskPageReqVO pageVO);

 /**
  * 获取详细信息
  * @param processInstanceId
  * @return
  */
 List<CamTaskVO> getProcessInstanceDetail(String processInstanceId);

 /**
  * 获得已办的流程任务分页
  *
  * @param username    用户编号
  * @param pageVO 分页请求
  *
  * @return 流程任务分页
  */
 IPage<CamTaskVO> getDoneTaskPage(String username, BpmTaskPageReqVO pageVO);

 /**
  * 获得流程任务 Map
  *
  * @param processInstanceIds 流程实例的编号数组
  *
  * @return 流程任务 Map
  */
/* default Map<String, List<Task>> getTaskMapByProcessInstanceIds(List<String> processInstanceIds) {
  return CollectionUtils.convertMultiMap(getTasksByProcessInstanceIds(processInstanceIds),
          Task::getProcessInstanceId);
 }*/

 /**
  * 开启任务
  * @param processKey 流程key
  * @param businessKey 关键字
  * @param username  第一个节点的 assignee
  * @param assigneeList 下一个节点的 执行者们
  * @return 返回当前实例id
  */
 String startProcessInstanceByKey(String processKey, String businessKey, String username, Map map, List<String> assigneeList);

 /**
  * 通过任务
  *
  * @param username 用户编号
  * @param taskId  任务id
  * @param reason  意见
  */
 void approveTask(String username, String taskId,String reason, Map map);

 /**
  * 不通过任务
  *
  * @param username 用户编号
  * @param taskId  任务id
  * @param reason  意见
  */
 void rejectTask(String username, String taskId,String reason, Map map);

 /**
  * 拒绝停止任务
  * @param username
  * @param taskId
  * @param reason
  */
 void stopTask(String username, String taskId,String reason);

 /**
  * 停止任务
  * @param username
  * @param processInstanceId
  * @param reason
  */
 void cancelProcessInstance(String username, String processInstanceId,String reason);

}
