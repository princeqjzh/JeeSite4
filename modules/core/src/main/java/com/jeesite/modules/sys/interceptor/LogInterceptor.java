/**
 * Copyright (c) 2013-Now http://jeesite.com All rights reserved.
 * No deletion without permission, or be held responsible to law.
 */
package com.jeesite.modules.sys.interceptor;

import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.MDC;
import org.springframework.core.NamedThreadLocal;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jeesite.common.idgen.IdGen;
import com.jeesite.common.lang.ByteUtils;
import com.jeesite.common.lang.DateUtils;
import com.jeesite.common.lang.StringUtils;
import com.jeesite.common.lang.TimeUtils;
import com.jeesite.common.network.IpUtils;
import com.jeesite.common.service.BaseService;
import com.jeesite.modules.sys.utils.LogUtils;
import com.jeesite.modules.sys.utils.UserUtils;

/**
 * 日志拦截器
 * @author ThinkGem
 * @version 2018-08-11
 */
public class LogInterceptor extends BaseService implements HandlerInterceptor {

	private static final String TRACE_ID = "TRACE_ID";
	private static final ThreadLocal<Long> startTimeThreadLocal =
			new NamedThreadLocal<Long>("LogInterceptor StartTime");
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, 
			Object handler) throws Exception {
		if (StringUtils.isBlank(MDC.get(TRACE_ID))) {
            MDC.put(TRACE_ID, IdGen.nextId());
        }
		long beginTime = System.currentTimeMillis();// 1、开始时间  
		startTimeThreadLocal.set(beginTime);		// 线程绑定变量（该数据只有当前请求的线程可见）  
		if (logger.isDebugEnabled()){
	        logger.debug("开始计时: {}  URI: {}  IP: {}", new SimpleDateFormat("hh:mm:ss.SSS")
	        	.format(beginTime), request.getRequestURI(), IpUtils.getRemoteAddr(request));
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, 
			ModelAndView modelAndView) throws Exception {
		if (modelAndView != null){
			logger.info("ViewName: " + modelAndView.getViewName() + " <<<<<<<<< " + request.getRequestURI() + " >>>>>>>>> " + handler);
		}
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
			Object handler, Exception ex) throws Exception {
		long endTime = System.currentTimeMillis(); 	// 2、结束时间
		long startTime = 0; // 得到线程绑定的局部变量（开始时间）
		if (startTimeThreadLocal != null){
			Long time = startTimeThreadLocal.get();
			if (time != null){
				startTime = time;
			}
			startTimeThreadLocal.remove(); // 用完之后销毁线程变量数据
		}
		if (startTime == 0){
			startTime = endTime + 1000;	// 得到 -1000 方便统计
		}
		long executeTime = endTime - startTime;	// 3、获取执行时间
		
		// 保存日志
		LogUtils.saveLog(UserUtils.getUser(), request, handler, ex, null, null, executeTime);
		
		// 打印JVM信息。
		if (logger.isDebugEnabled()){
			Runtime runtime = Runtime.getRuntime();
	        logger.debug("计时结束: {}  用时: {}  URI: {}  总内存: {}  已用内存: {}",
	        		DateUtils.formatDate(endTime, "hh:mm:ss.SSS"), TimeUtils.formatDateAgo(executeTime), request.getRequestURI(), 
					ByteUtils.formatByteSize(runtime.totalMemory()), ByteUtils.formatByteSize(runtime.totalMemory()-runtime.freeMemory())); 
		}
		MDC.remove(TRACE_ID);
	}

}
