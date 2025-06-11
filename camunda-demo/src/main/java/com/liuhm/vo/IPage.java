package com.liuhm.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * @ClassName：IPage
 * @Description: TODO
 * @Author: liuhaomin
 * @Date: 2024/11/28 14:38
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
public class IPage<T> {
    private List<T> records;
    private long total;

}
