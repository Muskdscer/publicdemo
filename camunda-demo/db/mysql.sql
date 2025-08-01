
--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

create table ACT_HI_CASEINST (
                                 ID_ varchar(64) not null,
                                 CASE_INST_ID_ varchar(64) not null,
                                 BUSINESS_KEY_ varchar(255),
                                 CASE_DEF_ID_ varchar(64) not null,
                                 CREATE_TIME_ datetime not null,
                                 CLOSE_TIME_ datetime,
                                 DURATION_ bigint,
                                 STATE_ integer,
                                 CREATE_USER_ID_ varchar(255),
                                 SUPER_CASE_INSTANCE_ID_ varchar(64),
                                 SUPER_PROCESS_INSTANCE_ID_ varchar(64),
                                 TENANT_ID_ varchar(64),
                                 primary key (ID_),
                                 unique (CASE_INST_ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_CASEACTINST (
                                    ID_ varchar(64) not null,
                                    PARENT_ACT_INST_ID_ varchar(64),
                                    CASE_DEF_ID_ varchar(64) not null,
                                    CASE_INST_ID_ varchar(64) not null,
                                    CASE_ACT_ID_ varchar(255) not null,
                                    TASK_ID_ varchar(64),
                                    CALL_PROC_INST_ID_ varchar(64),
                                    CALL_CASE_INST_ID_ varchar(64),
                                    CASE_ACT_NAME_ varchar(255),
                                    CASE_ACT_TYPE_ varchar(255),
                                    CREATE_TIME_ datetime not null,
                                    END_TIME_ datetime,
                                    DURATION_ bigint,
                                    STATE_ integer,
                                    REQUIRED_ boolean,
                                    TENANT_ID_ varchar(64),
                                    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create index ACT_IDX_HI_CAS_I_CLOSE on ACT_HI_CASEINST(CLOSE_TIME_);
create index ACT_IDX_HI_CAS_I_BUSKEY on ACT_HI_CASEINST(BUSINESS_KEY_);
create index ACT_IDX_HI_CAS_I_TENANT_ID on ACT_HI_CASEINST(TENANT_ID_);
create index ACT_IDX_HI_CAS_A_I_CREATE on ACT_HI_CASEACTINST(CREATE_TIME_);
create index ACT_IDX_HI_CAS_A_I_END on ACT_HI_CASEACTINST(END_TIME_);
create index ACT_IDX_HI_CAS_A_I_COMP on ACT_HI_CASEACTINST(CASE_ACT_ID_, END_TIME_, ID_);
create index ACT_IDX_HI_CAS_A_I_CASEINST on ACT_HI_CASEACTINST(CASE_INST_ID_, CASE_ACT_ID_);
create index ACT_IDX_HI_CAS_A_I_TENANT_ID on ACT_HI_CASEACTINST(TENANT_ID_);
--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- create decision definition table --
create table ACT_RE_DECISION_DEF (
                                     ID_ varchar(64) not null,
                                     REV_ integer,
                                     CATEGORY_ varchar(255),
                                     NAME_ varchar(255),
                                     KEY_ varchar(255) not null,
                                     VERSION_ integer not null,
                                     DEPLOYMENT_ID_ varchar(64),
                                     RESOURCE_NAME_ varchar(4000),
                                     DGRM_RESOURCE_NAME_ varchar(4000),
                                     DEC_REQ_ID_ varchar(64),
                                     DEC_REQ_KEY_ varchar(255),
                                     TENANT_ID_ varchar(64),
                                     HISTORY_TTL_ integer,
                                     VERSION_TAG_ varchar(64),
                                     primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create decision requirements definition table --
create table ACT_RE_DECISION_REQ_DEF (
                                         ID_ varchar(64) NOT NULL,
                                         REV_ integer,
                                         CATEGORY_ varchar(255),
                                         NAME_ varchar(255),
                                         KEY_ varchar(255) NOT NULL,
                                         VERSION_ integer NOT NULL,
                                         DEPLOYMENT_ID_ varchar(64),
                                         RESOURCE_NAME_ varchar(4000),
                                         DGRM_RESOURCE_NAME_ varchar(4000),
                                         TENANT_ID_ varchar(64),
                                         primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

alter table ACT_RE_DECISION_DEF
    add constraint ACT_FK_DEC_REQ
        foreign key (DEC_REQ_ID_)
            references ACT_RE_DECISION_REQ_DEF(ID_);

create index ACT_IDX_DEC_DEF_TENANT_ID on ACT_RE_DECISION_DEF(TENANT_ID_);
create index ACT_IDX_DEC_DEF_REQ_ID on ACT_RE_DECISION_DEF(DEC_REQ_ID_);
create index ACT_IDX_DEC_REQ_DEF_TENANT_ID on ACT_RE_DECISION_REQ_DEF(TENANT_ID_);

--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- create history decision instance table --
create table ACT_HI_DECINST (
                                ID_ varchar(64) NOT NULL,
                                DEC_DEF_ID_ varchar(64) NOT NULL,
                                DEC_DEF_KEY_ varchar(255) NOT NULL,
                                DEC_DEF_NAME_ varchar(255),
                                PROC_DEF_KEY_ varchar(255),
                                PROC_DEF_ID_ varchar(64),
                                PROC_INST_ID_ varchar(64),
                                CASE_DEF_KEY_ varchar(255),
                                CASE_DEF_ID_ varchar(64),
                                CASE_INST_ID_ varchar(64),
                                ACT_INST_ID_ varchar(64),
                                ACT_ID_ varchar(255),
                                EVAL_TIME_ datetime not null,
                                REMOVAL_TIME_ datetime,
                                COLLECT_VALUE_ double,
                                USER_ID_ varchar(255),
                                ROOT_DEC_INST_ID_ varchar(64),
                                ROOT_PROC_INST_ID_ varchar(64),
                                DEC_REQ_ID_ varchar(64),
                                DEC_REQ_KEY_ varchar(255),
                                TENANT_ID_ varchar(64),
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create history decision input table --
create table ACT_HI_DEC_IN (
                               ID_ varchar(64) NOT NULL,
                               DEC_INST_ID_ varchar(64) NOT NULL,
                               CLAUSE_ID_ varchar(64),
                               CLAUSE_NAME_ varchar(255),
                               VAR_TYPE_ varchar(100),
                               BYTEARRAY_ID_ varchar(64),
                               DOUBLE_ double,
                               LONG_ bigint,
                               TEXT_ varchar(4000),
                               TEXT2_ varchar(4000),
                               TENANT_ID_ varchar(64),
                               CREATE_TIME_ datetime,
                               ROOT_PROC_INST_ID_ varchar(64),
                               REMOVAL_TIME_ datetime,
                               primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create history decision output table --
create table ACT_HI_DEC_OUT (
                                ID_ varchar(64) NOT NULL,
                                DEC_INST_ID_ varchar(64) NOT NULL,
                                CLAUSE_ID_ varchar(64),
                                CLAUSE_NAME_ varchar(255),
                                RULE_ID_ varchar(64),
                                RULE_ORDER_ integer,
                                VAR_NAME_ varchar(255),
                                VAR_TYPE_ varchar(100),
                                BYTEARRAY_ID_ varchar(64),
                                DOUBLE_ double,
                                LONG_ bigint,
                                TEXT_ varchar(4000),
                                TEXT2_ varchar(4000),
                                TENANT_ID_ varchar(64),
                                CREATE_TIME_ datetime,
                                ROOT_PROC_INST_ID_ varchar(64),
                                REMOVAL_TIME_ datetime,
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;


create index ACT_IDX_HI_DEC_INST_ID on ACT_HI_DECINST(DEC_DEF_ID_);
create index ACT_IDX_HI_DEC_INST_KEY on ACT_HI_DECINST(DEC_DEF_KEY_);
create index ACT_IDX_HI_DEC_INST_PI on ACT_HI_DECINST(PROC_INST_ID_);
create index ACT_IDX_HI_DEC_INST_CI on ACT_HI_DECINST(CASE_INST_ID_);
create index ACT_IDX_HI_DEC_INST_ACT on ACT_HI_DECINST(ACT_ID_);
create index ACT_IDX_HI_DEC_INST_ACT_INST on ACT_HI_DECINST(ACT_INST_ID_);
create index ACT_IDX_HI_DEC_INST_TIME on ACT_HI_DECINST(EVAL_TIME_);
create index ACT_IDX_HI_DEC_INST_TENANT_ID on ACT_HI_DECINST(TENANT_ID_);
create index ACT_IDX_HI_DEC_INST_ROOT_ID on ACT_HI_DECINST(ROOT_DEC_INST_ID_);
create index ACT_IDX_HI_DEC_INST_REQ_ID on ACT_HI_DECINST(DEC_REQ_ID_);
create index ACT_IDX_HI_DEC_INST_REQ_KEY on ACT_HI_DECINST(DEC_REQ_KEY_);
create index ACT_IDX_HI_DEC_INST_ROOT_PI on ACT_HI_DECINST(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_DEC_INST_RM_TIME on ACT_HI_DECINST(REMOVAL_TIME_);

create index ACT_IDX_HI_DEC_IN_INST on ACT_HI_DEC_IN(DEC_INST_ID_);
create index ACT_IDX_HI_DEC_IN_CLAUSE on ACT_HI_DEC_IN(DEC_INST_ID_, CLAUSE_ID_);
create index ACT_IDX_HI_DEC_IN_ROOT_PI on ACT_HI_DEC_IN(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_DEC_IN_RM_TIME on ACT_HI_DEC_IN(REMOVAL_TIME_);

create index ACT_IDX_HI_DEC_OUT_INST on ACT_HI_DEC_OUT(DEC_INST_ID_);
create index ACT_IDX_HI_DEC_OUT_RULE on ACT_HI_DEC_OUT(RULE_ORDER_, CLAUSE_ID_);
create index ACT_IDX_HI_DEC_OUT_ROOT_PI on ACT_HI_DEC_OUT(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_DEC_OUT_RM_TIME on ACT_HI_DEC_OUT(REMOVAL_TIME_);
--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

create table ACT_GE_PROPERTY (
                                 NAME_ varchar(64),
                                 VALUE_ varchar(300),
                                 REV_ integer,
                                 primary key (NAME_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

insert into ACT_GE_PROPERTY
values ('schema.version', 'fox', 1);

insert into ACT_GE_PROPERTY
values ('schema.history', 'create(fox)', 1);

insert into ACT_GE_PROPERTY
values ('next.dbid', '1', 1);

insert into ACT_GE_PROPERTY
values ('deployment.lock', '0', 1);

insert into ACT_GE_PROPERTY
values ('history.cleanup.job.lock', '0', 1);

insert into ACT_GE_PROPERTY
values ('startup.lock', '0', 1);

insert into ACT_GE_PROPERTY
values ('telemetry.lock', '0', 1);

insert into ACT_GE_PROPERTY
values ('installationId.lock', '0', 1);

create table ACT_GE_BYTEARRAY (
                                  ID_ varchar(64),
                                  REV_ integer,
                                  NAME_ varchar(255),
                                  DEPLOYMENT_ID_ varchar(64),
                                  BYTES_ LONGBLOB,
                                  GENERATED_ TINYINT,
                                  TENANT_ID_ varchar(64),
                                  TYPE_ integer,
                                  CREATE_TIME_ datetime,
                                  ROOT_PROC_INST_ID_ varchar(64),
                                  REMOVAL_TIME_ datetime,
                                  primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_GE_SCHEMA_LOG (
                                   ID_ varchar(64),
                                   TIMESTAMP_ datetime,
                                   VERSION_ varchar(255),
                                   primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

insert into ACT_GE_SCHEMA_LOG
values ('0', CURRENT_TIMESTAMP, '7.19.0');

create table ACT_RE_DEPLOYMENT (
                                   ID_ varchar(64),
                                   NAME_ varchar(255),
                                   DEPLOY_TIME_ datetime,
                                   SOURCE_ varchar(255),
                                   TENANT_ID_ varchar(64),
                                   primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_EXECUTION (
                                  ID_ varchar(64),
                                  REV_ integer,
                                  ROOT_PROC_INST_ID_ varchar(64),
                                  PROC_INST_ID_ varchar(64),
                                  BUSINESS_KEY_ varchar(255),
                                  PARENT_ID_ varchar(64),
                                  PROC_DEF_ID_ varchar(64),
                                  SUPER_EXEC_ varchar(64),
                                  SUPER_CASE_EXEC_ varchar(64),
                                  CASE_INST_ID_ varchar(64),
                                  ACT_ID_ varchar(255),
                                  ACT_INST_ID_ varchar(64),
                                  IS_ACTIVE_ TINYINT,
                                  IS_CONCURRENT_ TINYINT,
                                  IS_SCOPE_ TINYINT,
                                  IS_EVENT_SCOPE_ TINYINT,
                                  SUSPENSION_STATE_ integer,
                                  CACHED_ENT_STATE_ integer,
                                  SEQUENCE_COUNTER_ bigint,
                                  TENANT_ID_ varchar(64),
                                  primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_JOB (
                            ID_ varchar(64) NOT NULL,
                            REV_ integer,
                            TYPE_ varchar(255) NOT NULL,
                            LOCK_EXP_TIME_ datetime NULL,
                            LOCK_OWNER_ varchar(255),
                            EXCLUSIVE_ boolean,
                            EXECUTION_ID_ varchar(64),
                            PROCESS_INSTANCE_ID_ varchar(64),
                            PROCESS_DEF_ID_ varchar(64),
                            PROCESS_DEF_KEY_ varchar(255),
                            RETRIES_ integer,
                            EXCEPTION_STACK_ID_ varchar(64),
                            EXCEPTION_MSG_ varchar(4000),
                            FAILED_ACT_ID_ varchar(255),
                            DUEDATE_ datetime NULL,
                            REPEAT_ varchar(255),
                            REPEAT_OFFSET_ bigint DEFAULT 0,
                            HANDLER_TYPE_ varchar(255),
                            HANDLER_CFG_ varchar(4000),
                            DEPLOYMENT_ID_ varchar(64),
                            SUSPENSION_STATE_ integer NOT NULL DEFAULT 1,
                            JOB_DEF_ID_ varchar(64),
                            PRIORITY_ bigint NOT NULL DEFAULT 0,
                            SEQUENCE_COUNTER_ bigint,
                            TENANT_ID_ varchar(64),
                            CREATE_TIME_ datetime,
                            LAST_FAILURE_LOG_ID_ varchar(64),
                            primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_JOBDEF (
                               ID_ varchar(64) NOT NULL,
                               REV_ integer,
                               PROC_DEF_ID_ varchar(64),
                               PROC_DEF_KEY_ varchar(255),
                               ACT_ID_ varchar(255),
                               JOB_TYPE_ varchar(255) NOT NULL,
                               JOB_CONFIGURATION_ varchar(255),
                               SUSPENSION_STATE_ integer,
                               JOB_PRIORITY_ bigint,
                               TENANT_ID_ varchar(64),
                               DEPLOYMENT_ID_ varchar(64),
                               primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RE_PROCDEF (
                                ID_ varchar(64) not null,
                                REV_ integer,
                                CATEGORY_ varchar(255),
                                NAME_ varchar(255),
                                KEY_ varchar(255) not null,
                                VERSION_ integer not null,
                                DEPLOYMENT_ID_ varchar(64),
                                RESOURCE_NAME_ varchar(4000),
                                DGRM_RESOURCE_NAME_ varchar(4000),
                                HAS_START_FORM_KEY_ TINYINT,
                                SUSPENSION_STATE_ integer,
                                TENANT_ID_ varchar(64),
                                VERSION_TAG_ varchar(64),
                                HISTORY_TTL_ integer,
                                STARTABLE_ boolean NOT NULL default TRUE,
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RE_CAMFORMDEF (
                                   ID_ varchar(64) not null,
                                   REV_ integer,
                                   KEY_ varchar(255) not null,
                                   VERSION_ integer not null,
                                   DEPLOYMENT_ID_ varchar(64),
                                   RESOURCE_NAME_ varchar(4000),
                                   TENANT_ID_ varchar(64),
                                   primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_TASK (
                             ID_ varchar(64),
                             REV_ integer,
                             EXECUTION_ID_ varchar(64),
                             PROC_INST_ID_ varchar(64),
                             PROC_DEF_ID_ varchar(64),
                             CASE_EXECUTION_ID_ varchar(64),
                             CASE_INST_ID_ varchar(64),
                             CASE_DEF_ID_ varchar(64),
                             NAME_ varchar(255),
                             PARENT_TASK_ID_ varchar(64),
                             DESCRIPTION_ varchar(4000),
                             TASK_DEF_KEY_ varchar(255),
                             OWNER_ varchar(255),
                             ASSIGNEE_ varchar(255),
                             DELEGATION_ varchar(64),
                             PRIORITY_ integer,
                             CREATE_TIME_ datetime,
                             LAST_UPDATED_ datetime,
                             DUE_DATE_ datetime,
                             FOLLOW_UP_DATE_ datetime,
                             SUSPENSION_STATE_ integer,
                             TENANT_ID_ varchar(64),
                             primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_IDENTITYLINK (
                                     ID_ varchar(64),
                                     REV_ integer,
                                     GROUP_ID_ varchar(255),
                                     TYPE_ varchar(255),
                                     USER_ID_ varchar(255),
                                     TASK_ID_ varchar(64),
                                     PROC_DEF_ID_ varchar(64),
                                     TENANT_ID_ varchar(64),
                                     primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_VARIABLE (
                                 ID_ varchar(64) not null,
                                 REV_ integer,
                                 TYPE_ varchar(255) not null,
                                 NAME_ varchar(255) not null,
                                 EXECUTION_ID_ varchar(64),
                                 PROC_INST_ID_ varchar(64),
                                 PROC_DEF_ID_ varchar(64),
                                 CASE_EXECUTION_ID_ varchar(64),
                                 CASE_INST_ID_ varchar(64),
                                 TASK_ID_ varchar(64),
                                 BATCH_ID_ varchar(64),
                                 BYTEARRAY_ID_ varchar(64),
                                 DOUBLE_ double,
                                 LONG_ bigint,
                                 TEXT_ varchar(4000),
                                 TEXT2_ varchar(4000),
                                 VAR_SCOPE_ varchar(64) not null,
                                 SEQUENCE_COUNTER_ bigint,
                                 IS_CONCURRENT_LOCAL_ TINYINT,
                                 TENANT_ID_ varchar(64),
                                 primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_EVENT_SUBSCR (
                                     ID_ varchar(64) not null,
                                     REV_ integer,
                                     EVENT_TYPE_ varchar(255) not null,
                                     EVENT_NAME_ varchar(255),
                                     EXECUTION_ID_ varchar(64),
                                     PROC_INST_ID_ varchar(64),
                                     ACTIVITY_ID_ varchar(255),
                                     CONFIGURATION_ varchar(255),
                                     CREATED_ datetime not null,
                                     TENANT_ID_ varchar(64),
                                     primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_INCIDENT (
                                 ID_ varchar(64) not null,
                                 REV_ integer not null,
                                 INCIDENT_TIMESTAMP_ datetime not null,
                                 INCIDENT_MSG_ varchar(4000),
                                 INCIDENT_TYPE_ varchar(255) not null,
                                 EXECUTION_ID_ varchar(64),
                                 ACTIVITY_ID_ varchar(255),
                                 FAILED_ACTIVITY_ID_ varchar(255),
                                 PROC_INST_ID_ varchar(64),
                                 PROC_DEF_ID_ varchar(64),
                                 CAUSE_INCIDENT_ID_ varchar(64),
                                 ROOT_CAUSE_INCIDENT_ID_ varchar(64),
                                 CONFIGURATION_ varchar(255),
                                 TENANT_ID_ varchar(64),
                                 JOB_DEF_ID_ varchar(64),
                                 ANNOTATION_ varchar(4000),
                                 primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_AUTHORIZATION (
                                      ID_ varchar(64) not null,
                                      REV_ integer not null,
                                      TYPE_ integer not null,
                                      GROUP_ID_ varchar(255),
                                      USER_ID_ varchar(255),
                                      RESOURCE_TYPE_ integer not null,
                                      RESOURCE_ID_ varchar(255),
                                      PERMS_ integer,
                                      REMOVAL_TIME_ datetime,
                                      ROOT_PROC_INST_ID_ varchar(64),
                                      primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_FILTER (
                               ID_ varchar(64) not null,
                               REV_ integer not null,
                               RESOURCE_TYPE_ varchar(255) not null,
                               NAME_ varchar(255) not null,
                               OWNER_ varchar(255),
                               QUERY_ LONGTEXT not null,
                               PROPERTIES_ LONGTEXT,
                               primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_METER_LOG (
                                  ID_ varchar(64) not null,
                                  NAME_ varchar(64) not null,
                                  REPORTER_ varchar(255),
                                  VALUE_ bigint,
                                  TIMESTAMP_ datetime,
                                  MILLISECONDS_ bigint DEFAULT 0,
                                  primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_TASK_METER_LOG (
                                       ID_ varchar(64) not null,
                                       ASSIGNEE_HASH_ bigint,
                                       TIMESTAMP_ datetime,
                                       primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_EXT_TASK (
                                 ID_ varchar(64) not null,
                                 REV_ integer not null,
                                 WORKER_ID_ varchar(255),
                                 TOPIC_NAME_ varchar(255),
                                 RETRIES_ integer,
                                 ERROR_MSG_ varchar(4000),
                                 ERROR_DETAILS_ID_ varchar(64),
                                 LOCK_EXP_TIME_ datetime NULL,
                                 SUSPENSION_STATE_ integer,
                                 EXECUTION_ID_ varchar(64),
                                 PROC_INST_ID_ varchar(64),
                                 PROC_DEF_ID_ varchar(64),
                                 PROC_DEF_KEY_ varchar(255),
                                 ACT_ID_ varchar(255),
                                 ACT_INST_ID_ varchar(64),
                                 TENANT_ID_ varchar(64),
                                 PRIORITY_ bigint NOT NULL DEFAULT 0,
                                 LAST_FAILURE_LOG_ID_ varchar(64),
                                 primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_RU_BATCH (
                              ID_ varchar(64) not null,
                              REV_ integer not null,
                              TYPE_ varchar(255),
                              TOTAL_JOBS_ integer,
                              JOBS_CREATED_ integer,
                              JOBS_PER_SEED_ integer,
                              INVOCATIONS_PER_JOB_ integer,
                              SEED_JOB_DEF_ID_ varchar(64),
                              BATCH_JOB_DEF_ID_ varchar(64),
                              MONITOR_JOB_DEF_ID_ varchar(64),
                              SUSPENSION_STATE_ integer,
                              CONFIGURATION_ varchar(255),
                              TENANT_ID_ varchar(64),
                              CREATE_USER_ID_ varchar(255),
                              START_TIME_ datetime,
                              EXEC_START_TIME_ datetime,
                              primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create index ACT_IDX_EXEC_ROOT_PI on ACT_RU_EXECUTION(ROOT_PROC_INST_ID_);
create index ACT_IDX_EXEC_BUSKEY on ACT_RU_EXECUTION(BUSINESS_KEY_);
create index ACT_IDX_EXEC_TENANT_ID on ACT_RU_EXECUTION(TENANT_ID_);
create index ACT_IDX_TASK_CREATE on ACT_RU_TASK(CREATE_TIME_);
create index ACT_IDX_TASK_LAST_UPDATED on ACT_RU_TASK(LAST_UPDATED_);
create index ACT_IDX_TASK_ASSIGNEE on ACT_RU_TASK(ASSIGNEE_);
create index ACT_IDX_TASK_OWNER on ACT_RU_TASK(OWNER_);
create index ACT_IDX_TASK_TENANT_ID on ACT_RU_TASK(TENANT_ID_);
create index ACT_IDX_IDENT_LNK_USER on ACT_RU_IDENTITYLINK(USER_ID_);
create index ACT_IDX_IDENT_LNK_GROUP on ACT_RU_IDENTITYLINK(GROUP_ID_);
create index ACT_IDX_EVENT_SUBSCR_CONFIG_ on ACT_RU_EVENT_SUBSCR(CONFIGURATION_);
create index ACT_IDX_EVENT_SUBSCR_TENANT_ID on ACT_RU_EVENT_SUBSCR(TENANT_ID_);

create index ACT_IDX_VARIABLE_TASK_ID on ACT_RU_VARIABLE(TASK_ID_);
create index ACT_IDX_VARIABLE_TENANT_ID on ACT_RU_VARIABLE(TENANT_ID_);
create index ACT_IDX_VARIABLE_TASK_NAME_TYPE on ACT_RU_VARIABLE(TASK_ID_, NAME_, TYPE_);

create index ACT_IDX_ATHRZ_PROCEDEF on ACT_RU_IDENTITYLINK(PROC_DEF_ID_);
create index ACT_IDX_INC_CONFIGURATION on ACT_RU_INCIDENT(CONFIGURATION_);
create index ACT_IDX_INC_TENANT_ID on ACT_RU_INCIDENT(TENANT_ID_);
-- CAM-5914
create index ACT_IDX_JOB_EXECUTION_ID on ACT_RU_JOB(EXECUTION_ID_);
-- this index needs to be limited in mysql see CAM-6938
create index ACT_IDX_JOB_HANDLER on ACT_RU_JOB(HANDLER_TYPE_(100),HANDLER_CFG_(155));
create index ACT_IDX_JOB_PROCINST on ACT_RU_JOB(PROCESS_INSTANCE_ID_);
create index ACT_IDX_JOB_TENANT_ID on ACT_RU_JOB(TENANT_ID_);
create index ACT_IDX_JOBDEF_TENANT_ID on ACT_RU_JOBDEF(TENANT_ID_);

-- new metric milliseconds column
CREATE INDEX ACT_IDX_METER_LOG_MS ON ACT_RU_METER_LOG(MILLISECONDS_);
CREATE INDEX ACT_IDX_METER_LOG_NAME_MS ON ACT_RU_METER_LOG(NAME_, MILLISECONDS_);
CREATE INDEX ACT_IDX_METER_LOG_REPORT ON ACT_RU_METER_LOG(NAME_, REPORTER_, MILLISECONDS_);

-- old metric timestamp column
CREATE INDEX ACT_IDX_METER_LOG_TIME ON ACT_RU_METER_LOG(TIMESTAMP_);
CREATE INDEX ACT_IDX_METER_LOG ON ACT_RU_METER_LOG(NAME_, TIMESTAMP_);

-- task metric timestamp column
CREATE INDEX ACT_IDX_TASK_METER_LOG_TIME ON ACT_RU_TASK_METER_LOG(TIMESTAMP_);

create index ACT_IDX_EXT_TASK_TOPIC on ACT_RU_EXT_TASK(TOPIC_NAME_);
create index ACT_IDX_EXT_TASK_TENANT_ID on ACT_RU_EXT_TASK(TENANT_ID_);
create index ACT_IDX_EXT_TASK_PRIORITY ON ACT_RU_EXT_TASK(PRIORITY_);
create index ACT_IDX_EXT_TASK_ERR_DETAILS ON ACT_RU_EXT_TASK(ERROR_DETAILS_ID_);
create index ACT_IDX_AUTH_GROUP_ID on ACT_RU_AUTHORIZATION(GROUP_ID_);
create index ACT_IDX_JOB_JOB_DEF_ID on ACT_RU_JOB(JOB_DEF_ID_);

alter table ACT_GE_BYTEARRAY
    add constraint ACT_FK_BYTEARR_DEPL
        foreign key (DEPLOYMENT_ID_)
            references ACT_RE_DEPLOYMENT (ID_);

alter table ACT_RU_EXECUTION
    add constraint ACT_FK_EXE_PROCINST
        foreign key (PROC_INST_ID_)
            references ACT_RU_EXECUTION (ID_) on delete cascade on update cascade;

alter table ACT_RU_EXECUTION
    add constraint ACT_FK_EXE_PARENT
        foreign key (PARENT_ID_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_EXECUTION
    add constraint ACT_FK_EXE_SUPER
        foreign key (SUPER_EXEC_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_EXECUTION
    add constraint ACT_FK_EXE_PROCDEF
        foreign key (PROC_DEF_ID_)
            references ACT_RE_PROCDEF (ID_);

alter table ACT_RU_IDENTITYLINK
    add constraint ACT_FK_TSKASS_TASK
        foreign key (TASK_ID_)
            references ACT_RU_TASK (ID_);

alter table ACT_RU_IDENTITYLINK
    add constraint ACT_FK_ATHRZ_PROCEDEF
        foreign key (PROC_DEF_ID_)
            references ACT_RE_PROCDEF(ID_);

alter table ACT_RU_TASK
    add constraint ACT_FK_TASK_EXE
        foreign key (EXECUTION_ID_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_TASK
    add constraint ACT_FK_TASK_PROCINST
        foreign key (PROC_INST_ID_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_TASK
    add constraint ACT_FK_TASK_PROCDEF
        foreign key (PROC_DEF_ID_)
            references ACT_RE_PROCDEF (ID_);

alter table ACT_RU_VARIABLE
    add constraint ACT_FK_VAR_EXE
        foreign key (EXECUTION_ID_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_VARIABLE
    add constraint ACT_FK_VAR_PROCINST
        foreign key (PROC_INST_ID_)
            references ACT_RU_EXECUTION(ID_);

alter table ACT_RU_VARIABLE
    add constraint ACT_FK_VAR_BYTEARRAY
        foreign key (BYTEARRAY_ID_)
            references ACT_GE_BYTEARRAY (ID_);

alter table ACT_RU_JOB
    add constraint ACT_FK_JOB_EXCEPTION
        foreign key (EXCEPTION_STACK_ID_)
            references ACT_GE_BYTEARRAY (ID_);

alter table ACT_RU_EVENT_SUBSCR
    add constraint ACT_FK_EVENT_EXEC
        foreign key (EXECUTION_ID_)
            references ACT_RU_EXECUTION(ID_);

alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_EXE
        foreign key (EXECUTION_ID_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_PROCINST
        foreign key (PROC_INST_ID_)
            references ACT_RU_EXECUTION (ID_);

alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_PROCDEF
        foreign key (PROC_DEF_ID_)
            references ACT_RE_PROCDEF (ID_);

alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_CAUSE
        foreign key (CAUSE_INCIDENT_ID_)
            references ACT_RU_INCIDENT (ID_) on delete cascade on update cascade;

alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_RCAUSE
        foreign key (ROOT_CAUSE_INCIDENT_ID_)
            references ACT_RU_INCIDENT (ID_) on delete cascade on update cascade;

alter table ACT_RU_EXT_TASK
    add constraint ACT_FK_EXT_TASK_ERROR_DETAILS
        foreign key (ERROR_DETAILS_ID_)
            references ACT_GE_BYTEARRAY (ID_);

create index ACT_IDX_INC_JOB_DEF on ACT_RU_INCIDENT(JOB_DEF_ID_);
alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_JOB_DEF
        foreign key (JOB_DEF_ID_)
            references ACT_RU_JOBDEF (ID_);

alter table ACT_RU_AUTHORIZATION
    add constraint ACT_UNIQ_AUTH_USER
        unique (USER_ID_,TYPE_,RESOURCE_TYPE_,RESOURCE_ID_);

alter table ACT_RU_AUTHORIZATION
    add constraint ACT_UNIQ_AUTH_GROUP
        unique (GROUP_ID_,TYPE_,RESOURCE_TYPE_,RESOURCE_ID_);

alter table ACT_RU_VARIABLE
    add constraint ACT_UNIQ_VARIABLE
        unique (VAR_SCOPE_, NAME_);

alter table ACT_RU_EXT_TASK
    add constraint ACT_FK_EXT_TASK_EXE
        foreign key (EXECUTION_ID_)
            references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_BATCH_SEED_JOB_DEF ON ACT_RU_BATCH(SEED_JOB_DEF_ID_);
alter table ACT_RU_BATCH
    add constraint ACT_FK_BATCH_SEED_JOB_DEF
        foreign key (SEED_JOB_DEF_ID_)
            references ACT_RU_JOBDEF (ID_);

create index ACT_IDX_BATCH_MONITOR_JOB_DEF ON ACT_RU_BATCH(MONITOR_JOB_DEF_ID_);
alter table ACT_RU_BATCH
    add constraint ACT_FK_BATCH_MONITOR_JOB_DEF
        foreign key (MONITOR_JOB_DEF_ID_)
            references ACT_RU_JOBDEF (ID_);

create index ACT_IDX_BATCH_JOB_DEF ON ACT_RU_BATCH(BATCH_JOB_DEF_ID_);
alter table ACT_RU_BATCH
    add constraint ACT_FK_BATCH_JOB_DEF
        foreign key (BATCH_JOB_DEF_ID_)
            references ACT_RU_JOBDEF (ID_);

create index ACT_IDX_BATCH_ID ON ACT_RU_VARIABLE(BATCH_ID_);
alter table ACT_RU_VARIABLE
    add constraint ACT_FK_VAR_BATCH
        foreign key (BATCH_ID_)
            references ACT_RU_BATCH (ID_);

-- indexes for deadlock problems - https://app.camunda.com/jira/browse/CAM-2567 --
create index ACT_IDX_INC_CAUSEINCID on ACT_RU_INCIDENT(CAUSE_INCIDENT_ID_);
create index ACT_IDX_INC_EXID on ACT_RU_INCIDENT(EXECUTION_ID_);
create index ACT_IDX_INC_PROCDEFID on ACT_RU_INCIDENT(PROC_DEF_ID_);
create index ACT_IDX_INC_PROCINSTID on ACT_RU_INCIDENT(PROC_INST_ID_);
create index ACT_IDX_INC_ROOTCAUSEINCID on ACT_RU_INCIDENT(ROOT_CAUSE_INCIDENT_ID_);
-- index for deadlock problem - https://app.camunda.com/jira/browse/CAM-4440 --
create index ACT_IDX_AUTH_RESOURCE_ID on ACT_RU_AUTHORIZATION(RESOURCE_ID_);
-- index to prevent deadlock on fk constraint - https://app.camunda.com/jira/browse/CAM-5440 --
create index ACT_IDX_EXT_TASK_EXEC on ACT_RU_EXT_TASK(EXECUTION_ID_);

-- indexes to improve deployment
create index ACT_IDX_BYTEARRAY_ROOT_PI on ACT_GE_BYTEARRAY(ROOT_PROC_INST_ID_);
create index ACT_IDX_BYTEARRAY_RM_TIME on ACT_GE_BYTEARRAY(REMOVAL_TIME_);
create index ACT_IDX_BYTEARRAY_NAME on ACT_GE_BYTEARRAY(NAME_);
create index ACT_IDX_DEPLOYMENT_NAME on ACT_RE_DEPLOYMENT(NAME_);
create index ACT_IDX_DEPLOYMENT_TENANT_ID on ACT_RE_DEPLOYMENT(TENANT_ID_);
create index ACT_IDX_JOBDEF_PROC_DEF_ID ON ACT_RU_JOBDEF(PROC_DEF_ID_);
create index ACT_IDX_JOB_HANDLER_TYPE ON ACT_RU_JOB(HANDLER_TYPE_);
create index ACT_IDX_EVENT_SUBSCR_EVT_NAME ON ACT_RU_EVENT_SUBSCR(EVENT_NAME_);
create index ACT_IDX_PROCDEF_DEPLOYMENT_ID ON ACT_RE_PROCDEF(DEPLOYMENT_ID_);
create index ACT_IDX_PROCDEF_TENANT_ID ON ACT_RE_PROCDEF(TENANT_ID_);
create index ACT_IDX_PROCDEF_VER_TAG ON ACT_RE_PROCDEF(VERSION_TAG_);

-- indices for history cleanup: https://jira.camunda.com/browse/CAM-11616
create index ACT_IDX_AUTH_ROOT_PI on ACT_RU_AUTHORIZATION(ROOT_PROC_INST_ID_);
create index ACT_IDX_AUTH_RM_TIME on ACT_RU_AUTHORIZATION(REMOVAL_TIME_);
--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

create table ACT_HI_PROCINST (
                                 ID_ varchar(64) not null,
                                 PROC_INST_ID_ varchar(64) not null,
                                 BUSINESS_KEY_ varchar(255),
                                 PROC_DEF_KEY_ varchar(255),
                                 PROC_DEF_ID_ varchar(64) not null,
                                 START_TIME_ datetime not null,
                                 END_TIME_ datetime,
                                 REMOVAL_TIME_ datetime,
                                 DURATION_ bigint,
                                 START_USER_ID_ varchar(255),
                                 START_ACT_ID_ varchar(255),
                                 END_ACT_ID_ varchar(255),
                                 SUPER_PROCESS_INSTANCE_ID_ varchar(64),
                                 ROOT_PROC_INST_ID_ varchar(64),
                                 SUPER_CASE_INSTANCE_ID_ varchar(64),
                                 CASE_INST_ID_ varchar(64),
                                 DELETE_REASON_ varchar(4000),
                                 TENANT_ID_ varchar(64),
                                 STATE_ varchar(255),
                                 primary key (ID_),
                                 unique (PROC_INST_ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_ACTINST (
                                ID_ varchar(64) not null,
                                PARENT_ACT_INST_ID_ varchar(64),
                                PROC_DEF_KEY_ varchar(255),
                                PROC_DEF_ID_ varchar(64) not null,
                                ROOT_PROC_INST_ID_ varchar(64),
                                PROC_INST_ID_ varchar(64) not null,
                                EXECUTION_ID_ varchar(64) not null,
                                ACT_ID_ varchar(255) not null,
                                TASK_ID_ varchar(64),
                                CALL_PROC_INST_ID_ varchar(64),
                                CALL_CASE_INST_ID_ varchar(64),
                                ACT_NAME_ varchar(255),
                                ACT_TYPE_ varchar(255) not null,
                                ASSIGNEE_ varchar(255),
                                START_TIME_ datetime not null,
                                END_TIME_ datetime,
                                DURATION_ bigint,
                                ACT_INST_STATE_ integer,
                                SEQUENCE_COUNTER_ bigint,
                                TENANT_ID_ varchar(64),
                                REMOVAL_TIME_ datetime,
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_TASKINST (
                                 ID_ varchar(64) not null,
                                 TASK_DEF_KEY_ varchar(255),
                                 PROC_DEF_KEY_ varchar(255),
                                 PROC_DEF_ID_ varchar(64),
                                 ROOT_PROC_INST_ID_ varchar(64),
                                 PROC_INST_ID_ varchar(64),
                                 EXECUTION_ID_ varchar(64),
                                 CASE_DEF_KEY_ varchar(255),
                                 CASE_DEF_ID_ varchar(64),
                                 CASE_INST_ID_ varchar(64),
                                 CASE_EXECUTION_ID_ varchar(64),
                                 ACT_INST_ID_ varchar(64),
                                 NAME_ varchar(255),
                                 PARENT_TASK_ID_ varchar(64),
                                 DESCRIPTION_ varchar(4000),
                                 OWNER_ varchar(255),
                                 ASSIGNEE_ varchar(255),
                                 START_TIME_ datetime not null,
                                 END_TIME_ datetime,
                                 DURATION_ bigint,
                                 DELETE_REASON_ varchar(4000),
                                 PRIORITY_ integer,
                                 DUE_DATE_ datetime,
                                 FOLLOW_UP_DATE_ datetime,
                                 TENANT_ID_ varchar(64),
                                 REMOVAL_TIME_ datetime,
                                 primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_VARINST (
                                ID_ varchar(64) not null,
                                PROC_DEF_KEY_ varchar(255),
                                PROC_DEF_ID_ varchar(64),
                                ROOT_PROC_INST_ID_ varchar(64),
                                PROC_INST_ID_ varchar(64),
                                EXECUTION_ID_ varchar(64),
                                ACT_INST_ID_ varchar(64),
                                CASE_DEF_KEY_ varchar(255),
                                CASE_DEF_ID_ varchar(64),
                                CASE_INST_ID_ varchar(64),
                                CASE_EXECUTION_ID_ varchar(64),
                                TASK_ID_ varchar(64),
                                NAME_ varchar(255) not null,
                                VAR_TYPE_ varchar(100),
                                CREATE_TIME_ datetime,
                                REV_ integer,
                                BYTEARRAY_ID_ varchar(64),
                                DOUBLE_ double,
                                LONG_ bigint,
                                TEXT_ varchar(4000),
                                TEXT2_ varchar(4000),
                                TENANT_ID_ varchar(64),
                                STATE_ varchar(20),
                                REMOVAL_TIME_ datetime,
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_DETAIL (
                               ID_ varchar(64) not null,
                               TYPE_ varchar(255) not null,
                               PROC_DEF_KEY_ varchar(255),
                               PROC_DEF_ID_ varchar(64),
                               ROOT_PROC_INST_ID_ varchar(64),
                               PROC_INST_ID_ varchar(64),
                               EXECUTION_ID_ varchar(64),
                               CASE_DEF_KEY_ varchar(255),
                               CASE_DEF_ID_ varchar(64),
                               CASE_INST_ID_ varchar(64),
                               CASE_EXECUTION_ID_ varchar(64),
                               TASK_ID_ varchar(64),
                               ACT_INST_ID_ varchar(64),
                               VAR_INST_ID_ varchar(64),
                               NAME_ varchar(255) not null,
                               VAR_TYPE_ varchar(255),
                               REV_ integer,
                               TIME_ datetime not null,
                               BYTEARRAY_ID_ varchar(64),
                               DOUBLE_ double,
                               LONG_ bigint,
                               TEXT_ varchar(4000),
                               TEXT2_ varchar(4000),
                               SEQUENCE_COUNTER_ bigint,
                               TENANT_ID_ varchar(64),
                               OPERATION_ID_ varchar(64),
                               REMOVAL_TIME_ datetime,
                               INITIAL_ boolean,
                               primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_IDENTITYLINK (
                                     ID_ varchar(64) not null,
                                     TIMESTAMP_ timestamp not null,
                                     TYPE_ varchar(255),
                                     USER_ID_ varchar(255),
                                     GROUP_ID_ varchar(255),
                                     TASK_ID_ varchar(64),
                                     ROOT_PROC_INST_ID_ varchar(64),
                                     PROC_DEF_ID_ varchar(64),
                                     OPERATION_TYPE_ varchar(64),
                                     ASSIGNER_ID_ varchar(64),
                                     PROC_DEF_KEY_ varchar(255),
                                     TENANT_ID_ varchar(64),
                                     REMOVAL_TIME_ datetime,
                                     primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_COMMENT (
                                ID_ varchar(64) not null,
                                TYPE_ varchar(255),
                                TIME_ datetime not null,
                                USER_ID_ varchar(255),
                                TASK_ID_ varchar(64),
                                ROOT_PROC_INST_ID_ varchar(64),
                                PROC_INST_ID_ varchar(64),
                                ACTION_ varchar(255),
                                MESSAGE_ varchar(4000),
                                FULL_MSG_ LONGBLOB,
                                TENANT_ID_ varchar(64),
                                REMOVAL_TIME_ datetime,
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_ATTACHMENT (
                                   ID_ varchar(64) not null,
                                   REV_ integer,
                                   USER_ID_ varchar(255),
                                   NAME_ varchar(255),
                                   DESCRIPTION_ varchar(4000),
                                   TYPE_ varchar(255),
                                   TASK_ID_ varchar(64),
                                   ROOT_PROC_INST_ID_ varchar(64),
                                   PROC_INST_ID_ varchar(64),
                                   URL_ varchar(4000),
                                   CONTENT_ID_ varchar(64),
                                   TENANT_ID_ varchar(64),
                                   CREATE_TIME_ datetime,
                                   REMOVAL_TIME_ datetime,
                                   primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_OP_LOG (
                               ID_ varchar(64) not null,
                               DEPLOYMENT_ID_ varchar(64),
                               PROC_DEF_ID_ varchar(64),
                               PROC_DEF_KEY_ varchar(255),
                               ROOT_PROC_INST_ID_ varchar(64),
                               PROC_INST_ID_ varchar(64),
                               EXECUTION_ID_ varchar(64),
                               CASE_DEF_ID_ varchar(64),
                               CASE_INST_ID_ varchar(64),
                               CASE_EXECUTION_ID_ varchar(64),
                               TASK_ID_ varchar(64),
                               JOB_ID_ varchar(64),
                               JOB_DEF_ID_ varchar(64),
                               BATCH_ID_ varchar(64),
                               USER_ID_ varchar(255),
                               TIMESTAMP_ timestamp not null,
                               OPERATION_TYPE_ varchar(64),
                               OPERATION_ID_ varchar(64),
                               ENTITY_TYPE_ varchar(30),
                               PROPERTY_ varchar(64),
                               ORG_VALUE_ varchar(4000),
                               NEW_VALUE_ varchar(4000),
                               TENANT_ID_ varchar(64),
                               REMOVAL_TIME_ datetime,
                               CATEGORY_ varchar(64),
                               EXTERNAL_TASK_ID_ varchar(64),
                               ANNOTATION_ varchar(4000),
                               primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_INCIDENT (
                                 ID_ varchar(64) not null,
                                 PROC_DEF_KEY_ varchar(255),
                                 PROC_DEF_ID_ varchar(64),
                                 ROOT_PROC_INST_ID_ varchar(64),
                                 PROC_INST_ID_ varchar(64),
                                 EXECUTION_ID_ varchar(64),
                                 CREATE_TIME_ timestamp not null,
                                 END_TIME_ timestamp null,
                                 INCIDENT_MSG_ varchar(4000),
                                 INCIDENT_TYPE_ varchar(255) not null,
                                 ACTIVITY_ID_ varchar(255),
                                 FAILED_ACTIVITY_ID_ varchar(255),
                                 CAUSE_INCIDENT_ID_ varchar(64),
                                 ROOT_CAUSE_INCIDENT_ID_ varchar(64),
                                 CONFIGURATION_ varchar(255),
                                 HISTORY_CONFIGURATION_ varchar(255),
                                 INCIDENT_STATE_ integer,
                                 TENANT_ID_ varchar(64),
                                 JOB_DEF_ID_ varchar(64),
                                 ANNOTATION_ varchar(4000),
                                 REMOVAL_TIME_ datetime,
                                 primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_JOB_LOG (
                                ID_ varchar(64) not null,
                                TIMESTAMP_ datetime not null,
                                JOB_ID_ varchar(64) not null,
                                JOB_DUEDATE_ datetime NULL,
                                JOB_RETRIES_ integer,
                                JOB_PRIORITY_ bigint NOT NULL DEFAULT 0,
                                JOB_EXCEPTION_MSG_ varchar(4000),
                                JOB_EXCEPTION_STACK_ID_ varchar(64),
                                JOB_STATE_ integer,
                                JOB_DEF_ID_ varchar(64),
                                JOB_DEF_TYPE_ varchar(255),
                                JOB_DEF_CONFIGURATION_ varchar(255),
                                ACT_ID_ varchar(255),
                                FAILED_ACT_ID_ varchar(255),
                                EXECUTION_ID_ varchar(64),
                                ROOT_PROC_INST_ID_ varchar(64),
                                PROCESS_INSTANCE_ID_ varchar(64),
                                PROCESS_DEF_ID_ varchar(64),
                                PROCESS_DEF_KEY_ varchar(255),
                                DEPLOYMENT_ID_ varchar(64),
                                SEQUENCE_COUNTER_ bigint,
                                TENANT_ID_ varchar(64),
                                HOSTNAME_ varchar(255),
                                REMOVAL_TIME_ datetime,
                                primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_BATCH (
                              ID_ varchar(64) not null,
                              TYPE_ varchar(255),
                              TOTAL_JOBS_ integer,
                              JOBS_PER_SEED_ integer,
                              INVOCATIONS_PER_JOB_ integer,
                              SEED_JOB_DEF_ID_ varchar(64),
                              MONITOR_JOB_DEF_ID_ varchar(64),
                              BATCH_JOB_DEF_ID_ varchar(64),
                              TENANT_ID_  varchar(64),
                              CREATE_USER_ID_ varchar(255),
                              START_TIME_ datetime not null,
                              END_TIME_ datetime,
                              REMOVAL_TIME_ datetime,
                              EXEC_START_TIME_ datetime,
                              primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_EXT_TASK_LOG (
                                     ID_ varchar(64) not null,
                                     TIMESTAMP_ timestamp not null,
                                     EXT_TASK_ID_ varchar(64) not null,
                                     RETRIES_ integer,
                                     TOPIC_NAME_ varchar(255),
                                     WORKER_ID_ varchar(255),
                                     PRIORITY_ bigint not null default 0,
                                     ERROR_MSG_ varchar(4000),
                                     ERROR_DETAILS_ID_ varchar(64),
                                     ACT_ID_ varchar(255),
                                     ACT_INST_ID_ varchar(64),
                                     EXECUTION_ID_ varchar(64),
                                     ROOT_PROC_INST_ID_ varchar(64),
                                     PROC_INST_ID_ varchar(64),
                                     PROC_DEF_ID_ varchar(64),
                                     PROC_DEF_KEY_ varchar(255),
                                     TENANT_ID_ varchar(64),
                                     STATE_ integer,
                                     REV_ integer,
                                     REMOVAL_TIME_ datetime,
                                     primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create index ACT_IDX_HI_PRO_INST_END on ACT_HI_PROCINST(END_TIME_);
create index ACT_IDX_HI_PRO_I_BUSKEY on ACT_HI_PROCINST(BUSINESS_KEY_);
create index ACT_IDX_HI_PRO_INST_TENANT_ID on ACT_HI_PROCINST(TENANT_ID_);
create index ACT_IDX_HI_PRO_INST_PROC_DEF_KEY on ACT_HI_PROCINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_PRO_INST_PROC_TIME on ACT_HI_PROCINST(START_TIME_, END_TIME_);
create index ACT_IDX_HI_PI_PDEFID_END_TIME on ACT_HI_PROCINST(PROC_DEF_ID_, END_TIME_);
create index ACT_IDX_HI_PRO_INST_ROOT_PI on ACT_HI_PROCINST(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_PRO_INST_RM_TIME on ACT_HI_PROCINST(REMOVAL_TIME_);

create index ACT_IDX_HI_ACTINST_ROOT_PI on ACT_HI_ACTINST(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_ACT_INST_START_END on ACT_HI_ACTINST(START_TIME_, END_TIME_);
create index ACT_IDX_HI_ACT_INST_END on ACT_HI_ACTINST(END_TIME_);
create index ACT_IDX_HI_ACT_INST_PROCINST on ACT_HI_ACTINST(PROC_INST_ID_, ACT_ID_);
create index ACT_IDX_HI_ACT_INST_COMP on ACT_HI_ACTINST(EXECUTION_ID_, ACT_ID_, END_TIME_, ID_);
create index ACT_IDX_HI_ACT_INST_STATS on ACT_HI_ACTINST(PROC_DEF_ID_, PROC_INST_ID_, ACT_ID_, END_TIME_, ACT_INST_STATE_);
create index ACT_IDX_HI_ACT_INST_TENANT_ID on ACT_HI_ACTINST(TENANT_ID_);
create index ACT_IDX_HI_ACT_INST_PROC_DEF_KEY on ACT_HI_ACTINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_AI_PDEFID_END_TIME on ACT_HI_ACTINST(PROC_DEF_ID_, END_TIME_);
create index ACT_IDX_HI_ACT_INST_RM_TIME on ACT_HI_ACTINST(REMOVAL_TIME_);

create index ACT_IDX_HI_TASKINST_ROOT_PI on ACT_HI_TASKINST(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_TASK_INST_TENANT_ID on ACT_HI_TASKINST(TENANT_ID_);
create index ACT_IDX_HI_TASK_INST_PROC_DEF_KEY on ACT_HI_TASKINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_TASKINST_PROCINST on ACT_HI_TASKINST(PROC_INST_ID_);
create index ACT_IDX_HI_TASKINSTID_PROCINST on ACT_HI_TASKINST(ID_,PROC_INST_ID_);
create index ACT_IDX_HI_TASK_INST_RM_TIME on ACT_HI_TASKINST(REMOVAL_TIME_);
create index ACT_IDX_HI_TASK_INST_START on ACT_HI_TASKINST(START_TIME_);
create index ACT_IDX_HI_TASK_INST_END on ACT_HI_TASKINST(END_TIME_);

create index ACT_IDX_HI_DETAIL_ROOT_PI on ACT_HI_DETAIL(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_DETAIL_PROC_INST on ACT_HI_DETAIL(PROC_INST_ID_);
create index ACT_IDX_HI_DETAIL_ACT_INST on ACT_HI_DETAIL(ACT_INST_ID_);
create index ACT_IDX_HI_DETAIL_CASE_INST on ACT_HI_DETAIL(CASE_INST_ID_);
create index ACT_IDX_HI_DETAIL_CASE_EXEC on ACT_HI_DETAIL(CASE_EXECUTION_ID_);
create index ACT_IDX_HI_DETAIL_TIME on ACT_HI_DETAIL(TIME_);
create index ACT_IDX_HI_DETAIL_NAME on ACT_HI_DETAIL(NAME_);
create index ACT_IDX_HI_DETAIL_TASK_ID on ACT_HI_DETAIL(TASK_ID_);
create index ACT_IDX_HI_DETAIL_TENANT_ID on ACT_HI_DETAIL(TENANT_ID_);
create index ACT_IDX_HI_DETAIL_PROC_DEF_KEY on ACT_HI_DETAIL(PROC_DEF_KEY_);
create index ACT_IDX_HI_DETAIL_BYTEAR on ACT_HI_DETAIL(BYTEARRAY_ID_);
create index ACT_IDX_HI_DETAIL_RM_TIME on ACT_HI_DETAIL(REMOVAL_TIME_);
create index ACT_IDX_HI_DETAIL_TASK_BYTEAR on ACT_HI_DETAIL(BYTEARRAY_ID_, TASK_ID_);
create index ACT_IDX_HI_DETAIL_VAR_INST_ID on ACT_HI_DETAIL(VAR_INST_ID_);

create index ACT_IDX_HI_IDENT_LNK_ROOT_PI on ACT_HI_IDENTITYLINK(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_IDENT_LNK_USER on ACT_HI_IDENTITYLINK(USER_ID_);
create index ACT_IDX_HI_IDENT_LNK_GROUP on ACT_HI_IDENTITYLINK(GROUP_ID_);
create index ACT_IDX_HI_IDENT_LNK_TENANT_ID on ACT_HI_IDENTITYLINK(TENANT_ID_);
create index ACT_IDX_HI_IDENT_LNK_PROC_DEF_KEY on ACT_HI_IDENTITYLINK(PROC_DEF_KEY_);
create index ACT_IDX_HI_IDENT_LINK_TASK on ACT_HI_IDENTITYLINK(TASK_ID_);
create index ACT_IDX_HI_IDENT_LINK_RM_TIME on ACT_HI_IDENTITYLINK(REMOVAL_TIME_);
create index ACT_IDX_HI_IDENT_LNK_TIMESTAMP on ACT_HI_IDENTITYLINK(TIMESTAMP_);

create index ACT_IDX_HI_VARINST_ROOT_PI on ACT_HI_VARINST(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_PROCVAR_PROC_INST on ACT_HI_VARINST(PROC_INST_ID_);
create index ACT_IDX_HI_PROCVAR_NAME_TYPE on ACT_HI_VARINST(NAME_, VAR_TYPE_);
create index ACT_IDX_HI_CASEVAR_CASE_INST on ACT_HI_VARINST(CASE_INST_ID_);
create index ACT_IDX_HI_VAR_INST_TENANT_ID on ACT_HI_VARINST(TENANT_ID_);
create index ACT_IDX_HI_VAR_INST_PROC_DEF_KEY on ACT_HI_VARINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_VARINST_BYTEAR on ACT_HI_VARINST(BYTEARRAY_ID_);
create index ACT_IDX_HI_VARINST_RM_TIME on ACT_HI_VARINST(REMOVAL_TIME_);
create index ACT_IDX_HI_VAR_PI_NAME_TYPE on ACT_HI_VARINST(PROC_INST_ID_, NAME_, VAR_TYPE_);
create index ACT_IDX_HI_VARINST_NAME on ACT_HI_VARINST(NAME_);
create index ACT_IDX_HI_VARINST_ACT_INST_ID on ACT_HI_VARINST(ACT_INST_ID_);

create index ACT_IDX_HI_INCIDENT_TENANT_ID on ACT_HI_INCIDENT(TENANT_ID_);
create index ACT_IDX_HI_INCIDENT_PROC_DEF_KEY on ACT_HI_INCIDENT(PROC_DEF_KEY_);
create index ACT_IDX_HI_INCIDENT_ROOT_PI on ACT_HI_INCIDENT(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_INCIDENT_PROCINST on ACT_HI_INCIDENT(PROC_INST_ID_);
create index ACT_IDX_HI_INCIDENT_RM_TIME on ACT_HI_INCIDENT(REMOVAL_TIME_);
create index ACT_IDX_HI_INCIDENT_CREATE_TIME on ACT_HI_INCIDENT(CREATE_TIME_);
create index ACT_IDX_HI_INCIDENT_END_TIME on ACT_HI_INCIDENT(END_TIME_);

create index ACT_IDX_HI_JOB_LOG_ROOT_PI on ACT_HI_JOB_LOG(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_JOB_LOG_PROCINST on ACT_HI_JOB_LOG(PROCESS_INSTANCE_ID_);
create index ACT_IDX_HI_JOB_LOG_PROCDEF on ACT_HI_JOB_LOG(PROCESS_DEF_ID_);
create index ACT_IDX_HI_JOB_LOG_TENANT_ID on ACT_HI_JOB_LOG(TENANT_ID_);
create index ACT_IDX_HI_JOB_LOG_JOB_DEF_ID on ACT_HI_JOB_LOG(JOB_DEF_ID_);
create index ACT_IDX_HI_JOB_LOG_PROC_DEF_KEY on ACT_HI_JOB_LOG(PROCESS_DEF_KEY_);
create index ACT_IDX_HI_JOB_LOG_EX_STACK on ACT_HI_JOB_LOG(JOB_EXCEPTION_STACK_ID_);
create index ACT_IDX_HI_JOB_LOG_RM_TIME on ACT_HI_JOB_LOG(REMOVAL_TIME_);
create index ACT_IDX_HI_JOB_LOG_JOB_CONF on ACT_HI_JOB_LOG(JOB_DEF_CONFIGURATION_);

create index ACT_HI_BAT_RM_TIME on ACT_HI_BATCH(REMOVAL_TIME_);

create index ACT_HI_EXT_TASK_LOG_ROOT_PI on ACT_HI_EXT_TASK_LOG(ROOT_PROC_INST_ID_);
create index ACT_HI_EXT_TASK_LOG_PROCINST on ACT_HI_EXT_TASK_LOG(PROC_INST_ID_);
create index ACT_HI_EXT_TASK_LOG_PROCDEF on ACT_HI_EXT_TASK_LOG(PROC_DEF_ID_);
create index ACT_HI_EXT_TASK_LOG_PROC_DEF_KEY on ACT_HI_EXT_TASK_LOG(PROC_DEF_KEY_);
create index ACT_HI_EXT_TASK_LOG_TENANT_ID on ACT_HI_EXT_TASK_LOG(TENANT_ID_);
create index ACT_IDX_HI_EXTTASKLOG_ERRORDET on ACT_HI_EXT_TASK_LOG(ERROR_DETAILS_ID_);
create index ACT_HI_EXT_TASK_LOG_RM_TIME on ACT_HI_EXT_TASK_LOG(REMOVAL_TIME_);

create index ACT_IDX_HI_OP_LOG_ROOT_PI on ACT_HI_OP_LOG(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_OP_LOG_PROCINST on ACT_HI_OP_LOG(PROC_INST_ID_);
create index ACT_IDX_HI_OP_LOG_PROCDEF on ACT_HI_OP_LOG(PROC_DEF_ID_);
create index ACT_IDX_HI_OP_LOG_TASK on ACT_HI_OP_LOG(TASK_ID_);
create index ACT_IDX_HI_OP_LOG_RM_TIME on ACT_HI_OP_LOG(REMOVAL_TIME_);
create index ACT_IDX_HI_OP_LOG_TIMESTAMP on ACT_HI_OP_LOG(TIMESTAMP_);
create index ACT_IDX_HI_OP_LOG_USER_ID on ACT_HI_OP_LOG(USER_ID_);
create index ACT_IDX_HI_OP_LOG_OP_TYPE on ACT_HI_OP_LOG(OPERATION_TYPE_);
create index ACT_IDX_HI_OP_LOG_ENTITY_TYPE on ACT_HI_OP_LOG(ENTITY_TYPE_);

create index ACT_IDX_HI_ATTACHMENT_CONTENT on ACT_HI_ATTACHMENT(CONTENT_ID_);
create index ACT_IDX_HI_ATTACHMENT_ROOT_PI on ACT_HI_ATTACHMENT(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_ATTACHMENT_PROCINST on ACT_HI_ATTACHMENT(PROC_INST_ID_);
create index ACT_IDX_HI_ATTACHMENT_TASK on ACT_HI_ATTACHMENT(TASK_ID_);
create index ACT_IDX_HI_ATTACHMENT_RM_TIME on ACT_HI_ATTACHMENT(REMOVAL_TIME_);

create index ACT_IDX_HI_COMMENT_TASK on ACT_HI_COMMENT(TASK_ID_);
create index ACT_IDX_HI_COMMENT_ROOT_PI on ACT_HI_COMMENT(ROOT_PROC_INST_ID_);
create index ACT_IDX_HI_COMMENT_PROCINST on ACT_HI_COMMENT(PROC_INST_ID_);
create index ACT_IDX_HI_COMMENT_RM_TIME on ACT_HI_COMMENT(REMOVAL_TIME_);
--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

create table ACT_ID_GROUP (
                              ID_ varchar(64),
                              REV_ integer,
                              NAME_ varchar(255),
                              TYPE_ varchar(255),
                              primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_ID_MEMBERSHIP (
                                   USER_ID_ varchar(64),
                                   GROUP_ID_ varchar(64),
                                   primary key (USER_ID_, GROUP_ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_ID_USER (
                             ID_ varchar(64),
                             REV_ integer,
                             FIRST_ varchar(255),
                             LAST_ varchar(255),
                             EMAIL_ varchar(255),
                             PWD_ varchar(255),
                             SALT_ varchar(255),
                             LOCK_EXP_TIME_ datetime NULL,
                             ATTEMPTS_ integer,
                             PICTURE_ID_ varchar(64),
                             primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_ID_INFO (
                             ID_ varchar(64),
                             REV_ integer,
                             USER_ID_ varchar(64),
                             TYPE_ varchar(64),
                             KEY_ varchar(255),
                             VALUE_ varchar(255),
                             PASSWORD_ LONGBLOB,
                             PARENT_ID_ varchar(255),
                             primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_ID_TENANT (
                               ID_ varchar(64),
                               REV_ integer,
                               NAME_ varchar(255),
                               primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_ID_TENANT_MEMBER (
                                      ID_ varchar(64) not null,
                                      TENANT_ID_ varchar(64) not null,
                                      USER_ID_ varchar(64),
                                      GROUP_ID_ varchar(64),
                                      primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

alter table ACT_ID_MEMBERSHIP
    add constraint ACT_FK_MEMB_GROUP
        foreign key (GROUP_ID_)
            references ACT_ID_GROUP (ID_);

alter table ACT_ID_MEMBERSHIP
    add constraint ACT_FK_MEMB_USER
        foreign key (USER_ID_)
            references ACT_ID_USER (ID_);

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_UNIQ_TENANT_MEMB_USER
        unique (TENANT_ID_, USER_ID_);

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_UNIQ_TENANT_MEMB_GROUP
        unique (TENANT_ID_, GROUP_ID_);

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_FK_TENANT_MEMB
        foreign key (TENANT_ID_)
            references ACT_ID_TENANT (ID_);

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_FK_TENANT_MEMB_USER
        foreign key (USER_ID_)
            references ACT_ID_USER (ID_);

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_FK_TENANT_MEMB_GROUP
        foreign key (GROUP_ID_)
            references ACT_ID_GROUP (ID_);
--
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- create case definition table --
create table ACT_RE_CASE_DEF (
                                 ID_ varchar(64) not null,
                                 REV_ integer,
                                 CATEGORY_ varchar(255),
                                 NAME_ varchar(255),
                                 KEY_ varchar(255) not null,
                                 VERSION_ integer not null,
                                 DEPLOYMENT_ID_ varchar(64),
                                 RESOURCE_NAME_ varchar(4000),
                                 DGRM_RESOURCE_NAME_ varchar(4000),
                                 TENANT_ID_ varchar(64),
                                 HISTORY_TTL_ integer,
                                 primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create case execution table --
create table ACT_RU_CASE_EXECUTION (
                                       ID_ varchar(64) NOT NULL,
                                       REV_ integer,
                                       CASE_INST_ID_ varchar(64),
                                       SUPER_CASE_EXEC_ varchar(64),
                                       SUPER_EXEC_ varchar(64),
                                       BUSINESS_KEY_ varchar(255),
                                       PARENT_ID_ varchar(64),
                                       CASE_DEF_ID_ varchar(64),
                                       ACT_ID_ varchar(255),
                                       PREV_STATE_ integer,
                                       CURRENT_STATE_ integer,
                                       REQUIRED_ boolean,
                                       TENANT_ID_ varchar(64),
                                       primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create case sentry part table --

create table ACT_RU_CASE_SENTRY_PART (
                                         ID_ varchar(64) NOT NULL,
                                         REV_ integer,
                                         CASE_INST_ID_ varchar(64),
                                         CASE_EXEC_ID_ varchar(64),
                                         SENTRY_ID_ varchar(255),
                                         TYPE_ varchar(255),
                                         SOURCE_CASE_EXEC_ID_ varchar(64),
                                         STANDARD_EVENT_ varchar(255),
                                         SOURCE_ varchar(255),
                                         VARIABLE_EVENT_ varchar(255),
                                         VARIABLE_NAME_ varchar(255),
                                         SATISFIED_ boolean,
                                         TENANT_ID_ varchar(64),
                                         primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create index on business key --
create index ACT_IDX_CASE_EXEC_BUSKEY on ACT_RU_CASE_EXECUTION(BUSINESS_KEY_);

-- https://app.camunda.com/jira/browse/CAM-9165
create index ACT_IDX_CASE_EXE_CASE_INST on ACT_RU_CASE_EXECUTION(CASE_INST_ID_);

-- create foreign key constraints on ACT_RU_CASE_EXECUTION --
alter table ACT_RU_CASE_EXECUTION
    add constraint ACT_FK_CASE_EXE_CASE_INST
        foreign key (CASE_INST_ID_)
            references ACT_RU_CASE_EXECUTION(ID_) on delete cascade on update cascade;

alter table ACT_RU_CASE_EXECUTION
    add constraint ACT_FK_CASE_EXE_PARENT
        foreign key (PARENT_ID_)
            references ACT_RU_CASE_EXECUTION(ID_);

alter table ACT_RU_CASE_EXECUTION
    add constraint ACT_FK_CASE_EXE_CASE_DEF
        foreign key (CASE_DEF_ID_)
            references ACT_RE_CASE_DEF(ID_);

-- create foreign key constraints on ACT_RU_VARIABLE --
alter table ACT_RU_VARIABLE
    add constraint ACT_FK_VAR_CASE_EXE
        foreign key (CASE_EXECUTION_ID_)
            references ACT_RU_CASE_EXECUTION(ID_);

alter table ACT_RU_VARIABLE
    add constraint ACT_FK_VAR_CASE_INST
        foreign key (CASE_INST_ID_)
            references ACT_RU_CASE_EXECUTION(ID_);

-- create foreign key constraints on ACT_RU_TASK --
alter table ACT_RU_TASK
    add constraint ACT_FK_TASK_CASE_EXE
        foreign key (CASE_EXECUTION_ID_)
            references ACT_RU_CASE_EXECUTION(ID_);

alter table ACT_RU_TASK
    add constraint ACT_FK_TASK_CASE_DEF
        foreign key (CASE_DEF_ID_)
            references ACT_RE_CASE_DEF(ID_);

-- create foreign key constraints on ACT_RU_CASE_SENTRY_PART --
alter table ACT_RU_CASE_SENTRY_PART
    add constraint ACT_FK_CASE_SENTRY_CASE_INST
        foreign key (CASE_INST_ID_)
            references ACT_RU_CASE_EXECUTION(ID_);

alter table ACT_RU_CASE_SENTRY_PART
    add constraint ACT_FK_CASE_SENTRY_CASE_EXEC
        foreign key (CASE_EXEC_ID_)
            references ACT_RU_CASE_EXECUTION(ID_);

create index ACT_IDX_CASE_DEF_TENANT_ID on ACT_RE_CASE_DEF(TENANT_ID_);
create index ACT_IDX_CASE_EXEC_TENANT_ID on ACT_RU_CASE_EXECUTION(TENANT_ID_);
