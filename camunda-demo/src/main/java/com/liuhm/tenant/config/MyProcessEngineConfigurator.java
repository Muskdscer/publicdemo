package com.liuhm.tenant.config;

import org.camunda.bpm.engine.ProcessEngine;
import org.camunda.bpm.engine.impl.ProcessEngineImpl;
import org.camunda.bpm.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.camunda.bpm.engine.spring.SpringProcessEngineConfiguration;
import org.camunda.bpm.spring.boot.starter.configuration.impl.DefaultProcessEngineConfiguration;

import java.util.Map;

/**
 * @ClassName：MyProcessEnginePlugin
 * @Description: TODO
 * @Author: liuhaomin
 * @Date: 2024/12/4 14:47
 */
@Deprecated
public class MyProcessEngineConfigurator extends DefaultProcessEngineConfiguration {


    @Override
    public void preInit(SpringProcessEngineConfiguration configuration) {
        super.preInit(configuration);
        configuration.setTenantIdProvider(new MyTenantIdProvider());
    }


    @Override
    public void preInit(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super.preInit(processEngineConfiguration);
        processEngineConfiguration.setTenantIdProvider(new MyTenantIdProvider());
    }





}
