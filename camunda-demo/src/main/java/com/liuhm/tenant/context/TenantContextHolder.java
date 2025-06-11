package com.liuhm.tenant.context;

import com.alibaba.ttl.TransmittableThreadLocal;

/**
 * saas 上下文 Holder
 */
public class TenantContextHolder {
    /**
     * 当前租户编号
     */
    private static final ThreadLocal<String> TENANT_ID = new TransmittableThreadLocal<>();


    /**
     * 获得租户编号。
     *
     * @return 租户编号
     */
    public static String getTenantId(){
        return TENANT_ID.get();
    }


    /**
     * 获得租户编号。如果不存在，则抛出 NullPointerException 异常
     *
     * @return 租户编号
     */
    public static String getRequiredTenantId(){
        String tenantId = getTenantId();
        if (tenantId == null) {
            throw new NullPointerException("TenantContextHolder 不存在租户编号！");
        }
        return tenantId;
    }

    public static void setTenantId(String tenantId){
        TENANT_ID.set(tenantId);
    }

    public static void clear(){
        TENANT_ID.remove();
    }

}
