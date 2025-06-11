package com.liuhm.tenant.config;

import com.baomidou.dynamic.datasource.toolkit.DynamicDataSourceContextHolder;
import com.liuhm.tenant.consts.TenantConsts;
import com.liuhm.tenant.context.TenantContextHolder;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.impl.cfg.multitenancy.TenantIdProvider;
import org.camunda.bpm.engine.impl.cfg.multitenancy.TenantIdProviderCaseInstanceContext;
import org.camunda.bpm.engine.impl.cfg.multitenancy.TenantIdProviderHistoricDecisionInstanceContext;
import org.camunda.bpm.engine.impl.cfg.multitenancy.TenantIdProviderProcessInstanceContext;
import org.slf4j.MDC;

/**
 * @ClassName：MyTenantIdProvider
 * @Description: TODO
 * @Author: liuhaomin
 * @Date: 2024/12/4 14:48
 */
@Deprecated
@Slf4j
public class MyTenantIdProvider implements TenantIdProvider {

    @Override
    public String provideTenantIdForProcessInstance(TenantIdProviderProcessInstanceContext tenantIdProviderProcessInstanceContext) {
        return getTenantId();
    }

    @Override
    public String provideTenantIdForCaseInstance(TenantIdProviderCaseInstanceContext tenantIdProviderCaseInstanceContext) {
        return getTenantId();
    }

    @Override
    public String provideTenantIdForHistoricDecisionInstance(TenantIdProviderHistoricDecisionInstanceContext tenantIdProviderHistoricDecisionInstanceContext) {
        return getTenantId();
    }
    public String getTenantId(){
        String tenantId = TenantContextHolder.getTenantId();
        if(tenantId == null){
            log.error("记录 租户id不能为空");
            tenantId = TenantConsts.MAIN_TENANT_ID;
        }
        return tenantId;
    }
}
