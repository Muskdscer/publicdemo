# camunda开源流程引擎数据库表结构详细介绍

> Camunda bpm流程引擎的数据库由多个表组成，表名都以ACT开头，第二部分是说明表用途的两字符标识。笔者在工作中用的Camunda7.19版本共49张表。

ACT_RE_*: 'RE’表示流程资源存储，这个前缀的表包含了流程定义和流程静态资源（图片，规则等），共5张表。
ACT_RU_*: 'RU’表示流程运行时。 这些运行时的表，包含流程实例，任务，变量，Job等运行中的数据。 Camunda只在流程实例执行过程中保存这些数据，在流程结束时就会删除这些记录， 这样运行时表的数据量最小，可以最快运行。共15张表。
ACT_ID_*: 'ID’表示组织用户信息，比如用户，组等，共6张表。
ACT_HI_*: 'HI’表示流程历史记录。 这些表包含历史数据，比如历史流程实例，变量，任务等，共18张表。
ACT_GE_*: ‘GE’表示流程通用数据， 用于不同场景下，共3张表。
一、数据表清单
分类	表名称	描述
流程资源存储	act_re_case_def	CMMN案例管理模型定义表
流程资源存储	act_re_decision_def	DMN决策模型定义表
流程资源存储	act_re_decision_req_def	待确定
流程资源存储	act_re_deployment	流程部署表
流程资源存储	act_re_procdef	BPMN流程模型定义表
流程运行时	act_ru_authorization	流程运行时收取表
流程运行时	act_ru_batch	流程执行批处理表
流程运行时	act_ru_case_execution	CMMN案例运行执行表
流程运行时	act_ru_case_sentry_part	待确定
流程运行时	act_ru_event_subscr	流程事件订阅表
流程运行时	act_ru_execution	BPMN流程运行时记录表
流程运行时	act_ru_ext_task	流程任务消息执行表
流程运行时	act_ru_filter	流程定义查询配置表
流程运行时	act_ru_identitylink	运行时流程人员表
流程运行时	act_ru_incident	运行时异常事件表
流程运行时	act_ru_job	流程运行时作业表
流程运行时	act_ru_jobdef	流程作业定义表
流程运行时	act_ru_meter_log	流程运行时度量日志表
流程运行时	act_ru_task	流程运行时任务表
流程运行时	act_ru_variable	流程运行时变量表
组织用户信息	act_id_group	群组信息表
组织用户信息	act_id_info	用户扩展信息表
组织用户信息	act_id_membership	用户群组关系表
组织用户信息	act_id_tenant	租户信息表
组织用户信息	act_id_tenant_member	用户租户关系表
组织用户信息	act_id_user	用户信息表
流程历史记录	act_hi_actinst	历史的活动实例表
流程历史记录	act_hi_attachment	历史的流程附件表
流程历史记录	act_hi_batch	历史的批处理记录表
流程历史记录	act_hi_caseactinst	历史的CMMN活动实例表
流程历史记录	act_hi_caseinst	历史的CMMN实例表
流程历史记录	act_hi_comment	历史的流程审批意见表
流程历史记录	act_hi_dec_in	历史的DMN变量输入表
流程历史记录	act_hi_dec_out	历史的DMN变量输出表
流程历史记录	act_hi_decinst	历史的DMN实例表
流程历史记录	act_hi_detail	历史的流程运行时变量详情记录表
流程历史记录	act_hi_ext_task_log	历史的流程任务消息执行表
流程历史记录	act_hi_identitylink	历史的流程运行过程中用户关系
流程历史记录	act_hi_incident	历史的流程异常事件记录表
流程历史记录	act_hi_job_log	历史的流程作业记录表
流程历史记录	act_hi_op_log	待确定
流程历史记录	act_hi_procinst	历史的流程实例
流程历史记录	act_hi_taskinst	历史的任务实例
流程历史记录	act_hi_varinst	历史的流程变量记录表
流程通用数据	act_ge_bytearray	流程引擎二进制数据表
流程通用数据	act_ge_property	流程引擎属性配置表
流程通用数据	act_ge_schema_log	数据库脚本执行日志表
流程引擎的最核心表是流程定义、流程执行、流程任务、流程变量和事件订阅表。它们之间的关系见下面的UML模型。


