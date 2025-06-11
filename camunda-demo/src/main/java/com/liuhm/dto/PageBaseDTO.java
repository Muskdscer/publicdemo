package com.liuhm.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 分页参数
 *
 * @author liuhaomin
 * @date 2024/7/27
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
public class PageBaseDTO implements Serializable {

    private static final long serialVersionUID = -5973084063000602579L;
    /**
     * 当前页数
     */
    private Integer page;
    /**
     * 每页大小
     */
    private Integer size;
}
