

/* Create Tables */

-- 文章表
CREATE TABLE js_cms_article
(
	id varchar(64) NOT NULL,
	category_code varchar(64) NOT NULL,
	module_type varchar(50),
	title varchar(255) NOT NULL,
	href varchar(1000),
	color varchar(50),
	image varchar(1000),
	keywords varchar(500),
	description varchar(500),
	weight decimal(10) DEFAULT 0,
	weight_date datetime,
	source char(1),
	copyfrom varchar(255),
	hits decimal(20) DEFAULT 0,
	hits_plus numeric(10),
	hits_minus numeric(10),
	word_count numeric(10),
	custom_content_view varchar(255),
	view_config varchar(1000),
	status char(1) DEFAULT '0' NOT NULL,
	create_by varchar(64) NOT NULL,
	create_date datetime NOT NULL,
	update_by varchar(64) NOT NULL,
	update_date datetime NOT NULL,
	remarks varchar(500),
	corp_code varchar(64) DEFAULT '0' NOT NULL,
	corp_name varchar(100) DEFAULT 'JeeSite' NOT NULL,
	PRIMARY KEY (id)
);


-- 文章详情表
CREATE TABLE js_cms_article_data
(
	id varchar(64) NOT NULL,
	content clob,
	relation varchar(1000),
	is_can_comment char(1),
	extend_s1 varchar(500),
	extend_s2 varchar(500),
	extend_s3 varchar(500),
	extend_s4 varchar(500),
	extend_s5 varchar(500),
	extend_s6 varchar(500),
	extend_s7 varchar(500),
	extend_s8 varchar(500),
	extend_i1 decimal(19),
	extend_i2 decimal(19),
	extend_i3 decimal(19),
	extend_i4 decimal(19),
	extend_f1 decimal(19,4),
	extend_f2 decimal(19,4),
	extend_f3 decimal(19,4),
	extend_f4 decimal(19,4),
	extend_d1 datetime,
	extend_d2 datetime,
	extend_d3 datetime,
	extend_d4 datetime,
	PRIMARY KEY (id)
);


-- 文章推荐位
CREATE TABLE js_cms_article_posid
(
	article_id varchar(64) NOT NULL,
	postid char(1) NOT NULL
);


-- 文章与标签关系
CREATE TABLE js_cms_article_tag
(
	article_id varchar(64) NOT NULL,
	tag_name varchar(200) NOT NULL
);


-- 栏目表
CREATE TABLE js_cms_category
(
	category_code varchar(64) NOT NULL,
	parent_code varchar(64) NOT NULL,
	parent_codes varchar(767) NOT NULL,
	tree_sort decimal(10) NOT NULL,
	tree_sorts varchar(767) NOT NULL,
	tree_leaf char(1) NOT NULL,
	tree_level decimal(4) NOT NULL,
	tree_names varchar(767) NOT NULL,
	category_name varchar(100) NOT NULL,
	site_code varchar(64) NOT NULL,
	module_type varchar(50),
	image varchar(255),
	href varchar(255),
	target varchar(20),
	keywords varchar(500),
	description varchar(500),
	in_menu char(1),
	in_list char(1),
	show_modes char(1),
	is_need_audit char(1),
	is_can_comment char(1),
	custom_list_view varchar(255),
	custom_content_view varchar(255),
	view_config varchar(1000),
	status char(1) DEFAULT '0' NOT NULL,
	create_by varchar(64) NOT NULL,
	create_date datetime NOT NULL,
	update_by varchar(64) NOT NULL,
	update_date datetime NOT NULL,
	remarks varchar(500),
	extend_s1 varchar(500),
	extend_s2 varchar(500),
	extend_s3 varchar(500),
	extend_s4 varchar(500),
	extend_s5 varchar(500),
	extend_s6 varchar(500),
	extend_s7 varchar(500),
	extend_s8 varchar(500),
	extend_i1 decimal(19),
	extend_i2 decimal(19),
	extend_i3 decimal(19),
	extend_i4 decimal(19),
	extend_f1 decimal(19,4),
	extend_f2 decimal(19,4),
	extend_f3 decimal(19,4),
	extend_f4 decimal(19,4),
	extend_d1 datetime,
	extend_d2 datetime,
	extend_d3 datetime,
	extend_d4 datetime,
	PRIMARY KEY (category_code)
);


-- 栏目与角色关联表
CREATE TABLE js_cms_category_role
(
	category_code varchar(64) NOT NULL,
	role_code varchar(64) NOT NULL,
	ctrl_type varchar(32),
	PRIMARY KEY (category_code, role_code)
);


-- 文章评论表
CREATE TABLE js_cms_comment
(
	id varchar(64) NOT NULL,
	category_code varchar(64) NOT NULL,
	article_id varchar(64) NOT NULL,
	parent_id varchar(64),
	article_title varchar(255) NOT NULL,
	content varchar(255) NOT NULL,
	name varchar(50),
	ip varchar(100),
	create_by varchar(64),
	create_date datetime NOT NULL,
	audit_user_code varchar(64),
	audit_date datetime,
	audit_comment varchar(200),
	hits_plus numeric(10),
	hits_minus numeric(10),
	status char(1) NOT NULL,
	corp_code varchar(64) DEFAULT '0' NOT NULL,
	corp_name varchar(100) DEFAULT 'JeeSite' NOT NULL,
	PRIMARY KEY (id)
);


-- 留言板表
CREATE TABLE js_cms_guestbook
(
	id varchar(64) NOT NULL,
	type char(1) NOT NULL,
	content varchar(255) NOT NULL,
	name varchar(100) NOT NULL,
	email varchar(100) NOT NULL,
	phone varchar(100) NOT NULL,
	workunit varchar(100) NOT NULL,
	ip varchar(100) NOT NULL,
	create_by varchar(64),
	create_date datetime,
	re_user_code varchar(64),
	re_date datetime,
	re_content varchar(100),
	status char(1) NOT NULL,
	corp_code varchar(64) DEFAULT '0' NOT NULL,
	corp_name varchar(100) DEFAULT 'JeeSite' NOT NULL,
	PRIMARY KEY (id)
);


-- 内容举报表
CREATE TABLE js_cms_report
(
	id varchar(64) NOT NULL,
	report_source char(1),
	report_content varchar(500),
	report_url varchar(1000),
	report_type char(1),
	report_cause varchar(500),
	PRIMARY KEY (id)
);


-- 站点表
CREATE TABLE js_cms_site
(
	site_code varchar(64) NOT NULL,
	site_name varchar(100) NOT NULL,
	site_sort decimal(10),
	title varchar(100) NOT NULL,
	logo varchar(1000),
	domain varchar(500),
	keywords varchar(500),
	description varchar(500),
	theme varchar(500),
	copyright varchar(1000),
	custom_index_view varchar(500),
	status char(1) DEFAULT '0' NOT NULL,
	create_by varchar(64) NOT NULL,
	create_date datetime NOT NULL,
	update_by varchar(64) NOT NULL,
	update_date datetime NOT NULL,
	remarks varchar(500),
	PRIMARY KEY (site_code)
);


-- 内容标签
CREATE TABLE js_cms_tag
(
	tag_name varchar(200) NOT NULL,
	clicknum numeric(10) NOT NULL,
	PRIMARY KEY (tag_name)
);


-- 访问日志表
CREATE TABLE js_cms_visit_log
(
	id varchar(64) NOT NULL,
	request_url varchar(1000),
	request_url_host varchar(128),
	source_referer varchar(1000),
	source_referer_host varchar(128),
	source_type char(1),
	search_engine varchar(200),
	search_word varchar(200),
	remote_addr varchar(50),
	user_agent varchar(500),
	user_language varchar(32),
	user_screen_size varchar(32),
	user_device varchar(32),
	user_os_name varchar(32),
	user_browser varchar(32),
	user_browser_version varchar(16),
	unique_visit_id varchar(64),
	visit_date char(8),
	visit_time datetime,
	is_new_visit char(1),
	first_visit_time decimal(20),
	prev_remain_time decimal(20),
	total_remain_time decimal(20),
	site_code varchar(64),
	site_name varchar(100),
	category_code varchar(64),
	category_name varchar(100),
	content_id varchar(64),
	content_title varchar(255),
	visit_user_code varchar(100),
	visit_user_name varchar(100),
	corp_code varchar(64) DEFAULT '0' NOT NULL,
	corp_name varchar(100) DEFAULT 'JeeSite' NOT NULL,
	PRIMARY KEY (id)
);



/* Create Indexes */

CREATE INDEX idx_cms_article_cb ON js_cms_article (create_by);
CREATE INDEX idx_cms_article_cc ON js_cms_article (category_code);
CREATE INDEX idx_cms_article_corp_code ON js_cms_article (corp_code);
CREATE INDEX idx_cms_article_status ON js_cms_article (status);
CREATE INDEX idx_cms_article_ud ON js_cms_article (update_date);
CREATE INDEX idx_cms_article_weight ON js_cms_article (weight);
CREATE INDEX idx_cms_category_pc ON js_cms_category (parent_code);
CREATE INDEX idx_cms_category_ts ON js_cms_category (tree_sort);
CREATE INDEX idx_cms_category_status ON js_cms_category (status);
CREATE INDEX idx_cms_category_tss ON js_cms_category (tree_sorts);
CREATE INDEX idx_cms_comment_catc ON js_cms_comment (category_code);
CREATE INDEX idx_cms_comment_ai ON js_cms_comment (article_id);
CREATE INDEX idx_cms_comment_cc ON js_cms_comment (corp_code);
CREATE INDEX idx_cms_comment_status ON js_cms_comment (status);
CREATE INDEX idx_cms_guestbook_cc ON js_cms_guestbook (corp_code);
CREATE INDEX idx_cms_guestbook_status ON js_cms_guestbook (status);
CREATE INDEX idx_cms_guestbook_type ON js_cms_guestbook (type);
CREATE INDEX idx_cms_site_status ON js_cms_site (status);
CREATE INDEX cms_visit_log_cc ON js_cms_visit_log (category_code);
CREATE INDEX cms_visit_log_ci ON js_cms_visit_log (content_id);
CREATE INDEX cms_visit_log_fvt ON js_cms_visit_log (first_visit_time);
CREATE INDEX cms_visit_log_inv ON js_cms_visit_log (is_new_visit);
CREATE INDEX cms_visit_log_ra ON js_cms_visit_log (remote_addr);
CREATE INDEX cms_visit_log_sc ON js_cms_visit_log (site_code);
CREATE INDEX cms_visit_log_uvid ON js_cms_visit_log (unique_visit_id);
CREATE INDEX cms_visit_log_vd ON js_cms_visit_log (visit_date);
CREATE INDEX cms_visit_log_vt ON js_cms_visit_log (visit_time);
CREATE INDEX idx_cms_visit_log_corpc ON js_cms_visit_log (corp_code);



