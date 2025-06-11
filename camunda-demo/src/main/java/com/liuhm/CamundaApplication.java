package com.liuhm;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

/**
 * @author Administrator
 */
@SpringBootApplication
@Slf4j
public class CamundaApplication {
	public static void main(String[] args) {
		try {
			ConfigurableApplicationContext run = SpringApplication.run(CamundaApplication.class, args);

			String[] beanNames = run.getBeanDefinitionNames();
			for (String beanName : beanNames) {
				System.out.println(beanName);
			}
		}catch (Exception e){
			log.error(ExceptionUtils.getStackTrace(e));
		}
	}
}
