package com.liuhm.tenant.context;

import com.baomidou.dynamic.datasource.DynamicRoutingDataSource;
import com.baomidou.dynamic.datasource.creator.DataSourceProperty;
import com.baomidou.dynamic.datasource.creator.DefaultDataSourceCreator;
import com.baomidou.dynamic.datasource.provider.DynamicDataSourceProvider;
import com.baomidou.dynamic.datasource.spring.boot.autoconfigure.DynamicDataSourceProperties;
import com.baomidou.dynamic.datasource.toolkit.DynamicDataSourceContextHolder;
import com.liuhm.tenant.consts.TenantConsts;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;

import javax.annotation.Resource;
import javax.sql.DataSource;
import java.util.List;

/**
 * @ClassName：SmDynamicRoutingDataSource
 * @Description: TODO
 * @Author: liuhaomin
 * @Date: 2024/5/9 8:44
 */
@Slf4j
public class SmDynamicRoutingDataSource extends DynamicRoutingDataSource {
    @Override
    public DataSource determineDataSource() {
        String tenantId = TenantContextHolder.getTenantId();
        log.debug("determineDataSource tenantId: {}", tenantId);
        // 不走租户回归本有操作 job 服务不走多租户
        if(!tenanted){
            String dsKey = DynamicDataSourceContextHolder.peek();
            return getDataSource(dsKey);
        }
        MDC.remove("err");

        if(DynamicDataSourceContextHolder.peek() == null){
            if(tenantId == null){
                // 错误日志后面打印sql的代码块需要检查
//                log.error("记录 租户id不能为空");
                MDC.put("err","1");
                tenantId = TenantConsts.MAIN_TENANT_ID;
            }
            if (tenantId.equals(TenantConsts.MAIN_TENANT_ID)) {
                // 给默认的数据源
                return getDataSource(tenantId);
            }
            DataSourceProperty dataSourceProperty = getDataSourceProperty(tenantId);
            createDatasourceIfAbsent(dataSourceProperty);
            return getDataSource(tenantId);
        } else {
            DataSourceProperty dataSourceProperty = getDataSourceProperty(DynamicDataSourceContextHolder.peek());
            createDatasourceIfAbsent(dataSourceProperty);
            return super.determineDataSource();
        }
    }

    public SmDynamicRoutingDataSource(List<DynamicDataSourceProvider> providers) {
        super(providers);
    }



    /**
     * 用于创建租户数据源的 Creator
     */
    @Resource
    @Lazy
    private DefaultDataSourceCreator dataSourceCreator;

    @Resource
    @Lazy
    private DynamicDataSourceProperties dynamicDataSourceProperties;
    /**
     * 配置多租户
     */
    @Value("${spring.datasource.dynamic.tenanted}")
    private Boolean tenanted;
    @Value("${spring.datasource.dynamic.tenant-schema}")
    private String tenantSchema;
    public DataSourceProperty getDataSourceProperty(String tenantId){

        DataSourceProperty dataSourceProperty = new DataSourceProperty();
        DataSourceProperty primaryDataSourceProperty = dynamicDataSourceProperties.getDatasource().get(dynamicDataSourceProperties.getPrimary());
        BeanUtils.copyProperties(primaryDataSourceProperty,dataSourceProperty);
        dataSourceProperty.setUrl(dataSourceProperty.getUrl().replace(tenantSchema,tenantSchema + "_" + tenantId));
        dataSourceProperty.setPoolName(tenantId);

        return dataSourceProperty;
    }

    private String createDatasourceIfAbsent(DataSourceProperty dataSourceProperty){
        // 1. 重点：如果数据源不存在，则进行创建
        if (isDataSourceNotExist(dataSourceProperty)) {
            // 问题一：为什么要加锁？因为，如果多个线程同时执行到这里，会导致多次创建数据源
            // 问题二：为什么要使用 poolName 加锁？保证多个不同的 poolName 可以并发创建数据源
            // 问题三：为什么要使用 intern 方法？因为，intern 方法，会返回一个字符串的常量池中的引用
            // intern 的说明，可见 https://www.cnblogs.com/xrq730/p/6662232.html 文章
            synchronized(dataSourceProperty.getPoolName().intern()){
                if (isDataSourceNotExist(dataSourceProperty)) {
                    log.debug("创建数据源：{}", dataSourceProperty.getPoolName());
                    DataSource dataSource = null;
                    try {
                        dataSource = dataSourceCreator.createDataSource(dataSourceProperty);
                    }catch (Exception e){
                        log.error("e {}",e);
                        if(e.getMessage().contains("Unknown database")){
                            throw new RuntimeException("租户不存在");
                        }
                        throw e;
                    }
                    addDataSource(dataSourceProperty.getPoolName(), dataSource);
                }
            }
        } else {
            log.debug("数据源已存在,无需创建：{}", dataSourceProperty.getPoolName());
        }
        // 2. 返回数据源的名字
        return dataSourceProperty.getPoolName();
    }


    private boolean isDataSourceNotExist(DataSourceProperty dataSourceProperty){
        return !getDataSources().containsKey(dataSourceProperty.getPoolName());
    }
}
