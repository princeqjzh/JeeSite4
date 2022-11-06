/**
 * Copyright (c) 2013-Now http://jeesite.com All rights reserved.
 * No deletion without permission, or be held responsible to law.
 */
package com.jeesite.modules.sys.dao;

import com.jeesite.common.dao.TreeDao;
import com.jeesite.common.mybatis.annotation.MyBatisDao;
import com.jeesite.modules.sys.entity.Office;

/**
 * 组织机构DAO接口
 * @author ThinkGem
 * @version 2017-03-23
 */
@MyBatisDao
public interface OfficeDao extends TreeDao<Office> {
	
}
