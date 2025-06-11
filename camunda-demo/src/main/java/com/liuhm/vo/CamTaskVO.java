package com.liuhm.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * @ClassName：CamTaskVO
 * @Description: TODO
 * @Author: liuhaomin
 * @Date: 2024/11/28 16:33
 */

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CamTaskVO {

    /**
     * 任务流程部署id
     */
    private String processDefinitionId;
    /**
     * 任务流程部署key
     */
    private String processDefinitionKey;

    /**
     * 任务流程id
     */
    private String processInstanceId;

    /**
     * taskDefinitionKey
     */
    private String taskDefinitionKey;


    /**
     * activityInstanceId
     */
    private String activityInstanceId;

    /**
     * 任务id
     */
    private String taskId;

    /**
     * 任务名称
     */
    private String name;


    /**
     * 任务审批人id
     */
    private String assignee;

    /**
     * 任务开始时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /**
     * 任务结束时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    private Long durationInMillis;

    /**
     * 删除结果
     */
    private String deleteReason;

    /**
     * 备注
     */
    private String reason;

    /**
     * 租户id
     */
    private String tenantId;
}
