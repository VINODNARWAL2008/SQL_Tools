CREATE DATABASE [dbadmin]
GO
USE [dbadmin]
GO
/****** Object:  Table [dbo].[SQL_AG_DB_State_Config]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_AG_DB_State_Config](
	[ServerName] [nvarchar](128) NULL,
	[Collection_Time] [datetime] NULL,
	[database_name] [varchar](30) NULL,
	[database_id] [int] NOT NULL,
	[group_id] [uniqueidentifier] NOT NULL,
	[replica_id] [uniqueidentifier] NOT NULL,
	[is_local] [bit] NULL,
	[is_failover_ready] [bit] NOT NULL,
	[is_pending_secondary_suspend] [bit] NOT NULL,
	[is_database_joined] [bit] NOT NULL,
	[is_suspended] [bit] NULL,
	[is_commit_participant] [bit] NULL,
	[suspend_reason_desc] [varchar](30) NULL,
	[synchronization_state_desc] [varchar](30) NULL,
	[synchronization_health_desc] [varchar](30) NULL,
	[database_state_desc] [varchar](30) NULL,
	[last_sent_lsn] [numeric](25, 0) NULL,
	[last_sent_time] [datetime] NULL,
	[last_received_lsn] [numeric](25, 0) NULL,
	[last_received_time] [datetime] NULL,
	[last_hardened_lsn] [numeric](25, 0) NULL,
	[last_hardened_time] [datetime] NULL,
	[last_redone_lsn] [numeric](25, 0) NULL,
	[last_redone_time] [datetime] NULL,
	[log_send_queue_size] [bigint] NULL,
	[log_send_rate] [bigint] NULL,
	[redo_queue_size] [bigint] NULL,
	[redo_rate] [bigint] NULL,
	[filestream_send_rate] [bigint] NULL,
	[end_of_log_lsn] [numeric](25, 0) NULL,
	[last_commit_lsn] [numeric](25, 0) NULL,
	[last_commit_time] [datetime] NULL,
	[low_water_mark_for_ghosts] [bigint] NULL,
	[recovery_lsn] [numeric](25, 0) NULL,
	[truncation_lsn] [numeric](25, 0) NULL,
	[file_id] [int] NULL,
	[error_type] [smallint] NULL,
	[page_id] [bigint] NULL,
	[page_status] [tinyint] NULL,
	[modification_time] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Drive_Latency]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Drive_Latency](
	[servername] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[Drive] [nvarchar](2) NULL,
	[Volume Mount Point] [nvarchar](256) NULL,
	[Read Latency] [bigint] NULL,
	[Write Latency] [bigint] NULL,
	[Overall Latency] [bigint] NULL,
	[Avg Bytes/Read] [bigint] NULL,
	[Avg Bytes/Write] [bigint] NULL,
	[Avg Bytes/Transfer] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Memory_Grant]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Memory_Grant](
	[Collection_Time] [varchar](30) NULL,
	[host_name] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL,
	[login_name] [nvarchar](128) NOT NULL,
	[client_interface_name] [nvarchar](32) NULL,
	[is_user_process] [bit] NOT NULL,
	[last_request_start_time] [datetime] NOT NULL,
	[last_request_end_time] [datetime] NULL,
	[session_id] [smallint] NOT NULL,
	[open_transaction_count] [int] NOT NULL,
	[granted_query_memory] [int] NULL,
	[grant_time] [datetime] NULL,
	[requested_memory_kb] [bigint] NULL,
	[granted_memory_kb] [bigint] NULL,
	[required_memory_kb] [bigint] NULL,
	[used_memory_kb] [bigint] NULL,
	[max_used_memory_kb] [bigint] NULL,
	[statement_text] [nvarchar](max) NULL,
	[input_buffer] [nvarchar](max) NULL,
	[request_row_count] [bigint] NULL,
	[session_row_count] [bigint] NOT NULL,
	[reads] [bigint] NOT NULL,
	[writes] [bigint] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[session_status] [nvarchar](30) NOT NULL,
	[request_status] [nvarchar](30) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Perf_CPU_Usage]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Perf_CPU_Usage](
	[InstanceName] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[Collection_Time] [datetime] NULL,
	[EventTime] [datetime] NULL,
	[CPUUsage_SQL] [int] NULL,
	[CPUUsage_Other] [int] NULL,
	[CPUUsage_Total] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Perf_Head_Blocker]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Perf_Head_Blocker](
	[InstanceName] [nvarchar](128) NULL,
	[databasename] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[lock type] [nvarchar](60) NOT NULL,
	[database] [nvarchar](128) NULL,
	[blk object] [bigint] NULL,
	[lock req] [nvarchar](60) NOT NULL,
	[waiter sid] [int] NOT NULL,
	[wait time] [bigint] NULL,
	[waiter_stmt] [nvarchar](max) NULL,
	[blocker sid] [smallint] NULL,
	[blocker_full_text] [nvarchar](max) NULL,
	[blocker_batch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Perf_Running_queries]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Perf_Running_queries](
	[InstanceName] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[Database_Name] [nvarchar](128) NULL,
	[ObjectName] [nvarchar](128) NULL,
	[statement_text] [nvarchar](max) NULL,
	[client_interface_name] [nvarchar](32) NULL,
	[host_name] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL,
	[login_name] [nvarchar](128) NULL,
	[login_time] [datetime] NULL,
	[last_request_start_time] [datetime] NULL,
	[last_request_end_time] [datetime] NULL,
	[auth_scheme] [nvarchar](40) NULL,
	[client_net_address] [nvarchar](48) NULL,
	[client_tcp_port] [int] NULL,
	[session_id] [smallint] NOT NULL,
	[request_id] [int] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[status] [nvarchar](30) NOT NULL,
	[command] [nvarchar](32) NOT NULL,
	[sql_handle] [varbinary](64) NULL,
	[statement_start_offset] [int] NULL,
	[statement_end_offset] [int] NULL,
	[plan_handle] [varbinary](64) NULL,
	[database_id] [smallint] NOT NULL,
	[user_id] [int] NOT NULL,
	[connection_id] [uniqueidentifier] NULL,
	[blocking_session_id] [smallint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_time] [int] NOT NULL,
	[last_wait_type] [nvarchar](60) NOT NULL,
	[wait_resource] [nvarchar](256) NOT NULL,
	[open_transaction_count] [int] NOT NULL,
	[open_resultset_count] [int] NOT NULL,
	[transaction_id] [bigint] NOT NULL,
	[context_info] [varbinary](128) NULL,
	[percent_complete] [real] NOT NULL,
	[estimated_completion_time] [bigint] NOT NULL,
	[cpu_time] [int] NOT NULL,
	[total_elapsed_time] [int] NOT NULL,
	[scheduler_id] [int] NULL,
	[task_address] [varbinary](8) NULL,
	[reads] [bigint] NOT NULL,
	[writes] [bigint] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[text_size] [int] NOT NULL,
	[language] [nvarchar](128) NULL,
	[date_format] [nvarchar](3) NULL,
	[date_first] [smallint] NOT NULL,
	[quoted_identifier] [bit] NOT NULL,
	[arithabort] [bit] NOT NULL,
	[ansi_null_dflt_on] [bit] NOT NULL,
	[ansi_defaults] [bit] NOT NULL,
	[ansi_warnings] [bit] NOT NULL,
	[ansi_padding] [bit] NOT NULL,
	[ansi_nulls] [bit] NOT NULL,
	[concat_null_yields_null] [bit] NOT NULL,
	[transaction_isolation_level] [smallint] NOT NULL,
	[lock_timeout] [int] NOT NULL,
	[deadlock_priority] [int] NOT NULL,
	[row_count] [bigint] NOT NULL,
	[prev_error] [int] NOT NULL,
	[nest_level] [int] NOT NULL,
	[granted_query_memory] [int] NOT NULL,
	[executing_managed_code] [bit] NOT NULL,
	[group_id] [int] NOT NULL,
	[query_hash] [binary](8) NULL,
	[query_plan_hash] [binary](8) NULL,
	[statement_sql_handle] [varbinary](64) NULL,
	[statement_context_id] [bigint] NULL,
	[dop] [int] NOT NULL,
	[parallel_worker_count] [int] NULL,
	[external_script_request_id] [uniqueidentifier] NULL,
	[is_resumable] [bit] NOT NULL,
	[page_resource] [varbinary](8) NULL,
	[page_server_reads] [bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Perf_Tempdb_Usage]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Perf_Tempdb_Usage](
	[InstanceName] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[start_time] [datetime] NULL,
	[cpu_time_ms] [int] NULL,
	[ObjectName] [nvarchar](128) NULL,
	[statement_text] [nvarchar](max) NULL,
	[session_internal_objects_alloc_page_count] [bigint] NULL,
	[session_internal_objects_dealloc_page_count] [bigint] NULL,
	[task_internal_objects_alloc_page_count] [bigint] NULL,
	[task_internal_objects_dealloc_page_count] [bigint] NULL,
	[log_reuse_wait] [tinyint] NULL,
	[log_reuse_wait_desc] [nvarchar](60) NULL,
	[session_id] [smallint] NOT NULL,
	[login_time] [datetime] NOT NULL,
	[host_name] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL,
	[host_process_id] [int] NULL,
	[client_version] [int] NULL,
	[client_interface_name] [nvarchar](32) NULL,
	[security_id] [varbinary](85) NOT NULL,
	[login_name] [nvarchar](128) NOT NULL,
	[nt_domain] [nvarchar](128) NULL,
	[nt_user_name] [nvarchar](128) NULL,
	[status] [nvarchar](30) NOT NULL,
	[context_info] [varbinary](128) NULL,
	[cpu_time] [int] NOT NULL,
	[memory_usage] [int] NOT NULL,
	[total_scheduled_time] [int] NOT NULL,
	[total_elapsed_time] [int] NOT NULL,
	[endpoint_id] [int] NOT NULL,
	[last_request_start_time] [datetime] NOT NULL,
	[last_request_end_time] [datetime] NULL,
	[reads] [bigint] NOT NULL,
	[writes] [bigint] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[is_user_process] [bit] NOT NULL,
	[text_size] [int] NOT NULL,
	[language] [nvarchar](128) NULL,
	[date_format] [nvarchar](3) NULL,
	[date_first] [smallint] NOT NULL,
	[quoted_identifier] [bit] NOT NULL,
	[arithabort] [bit] NOT NULL,
	[ansi_null_dflt_on] [bit] NOT NULL,
	[ansi_defaults] [bit] NOT NULL,
	[ansi_warnings] [bit] NOT NULL,
	[ansi_padding] [bit] NOT NULL,
	[ansi_nulls] [bit] NOT NULL,
	[concat_null_yields_null] [bit] NOT NULL,
	[transaction_isolation_level] [smallint] NOT NULL,
	[lock_timeout] [int] NOT NULL,
	[deadlock_priority] [int] NOT NULL,
	[row_count] [bigint] NOT NULL,
	[prev_error] [int] NOT NULL,
	[original_security_id] [varbinary](85) NOT NULL,
	[original_login_name] [nvarchar](128) NOT NULL,
	[last_successful_logon] [datetime] NULL,
	[last_unsuccessful_logon] [datetime] NULL,
	[unsuccessful_logons] [bigint] NULL,
	[group_id] [int] NOT NULL,
	[database_id] [smallint] NOT NULL,
	[authenticating_database_id] [int] NULL,
	[open_transaction_count] [int] NOT NULL,
	[page_server_reads] [bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Perf_Worker_Count]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Perf_Worker_Count](
	[InstanceName] [nvarchar](128) NULL,
	[databasename] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[current_tasks_count] [int] NULL,
	[current_workers_count] [int] NULL,
	[active_workers_count] [int] NULL,
	[work_queue_count] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_Sessions_Info]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_Sessions_Info](
	[InstanceName] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[spid] [smallint] NOT NULL,
	[kpid] [smallint] NOT NULL,
	[blocked] [smallint] NOT NULL,
	[waittype] [binary](2) NOT NULL,
	[waittime] [bigint] NOT NULL,
	[lastwaittype] [nchar](32) NOT NULL,
	[waitresource] [nchar](256) NOT NULL,
	[dbid] [smallint] NOT NULL,
	[uid] [smallint] NULL,
	[cpu] [int] NOT NULL,
	[physical_io] [bigint] NOT NULL,
	[memusage] [int] NOT NULL,
	[login_time] [datetime] NOT NULL,
	[last_batch] [datetime] NOT NULL,
	[ecid] [smallint] NOT NULL,
	[open_tran] [smallint] NOT NULL,
	[status] [nchar](30) NOT NULL,
	[sid] [binary](86) NOT NULL,
	[hostname] [nchar](128) NOT NULL,
	[program_name] [nchar](128) NOT NULL,
	[hostprocess] [nchar](10) NOT NULL,
	[cmd] [nchar](26) NOT NULL,
	[nt_domain] [nchar](128) NOT NULL,
	[nt_username] [nchar](128) NOT NULL,
	[net_address] [nchar](12) NOT NULL,
	[net_library] [nchar](12) NOT NULL,
	[loginame] [nchar](128) NOT NULL,
	[context_info] [binary](128) NOT NULL,
	[sql_handle] [binary](20) NOT NULL,
	[stmt_start] [int] NOT NULL,
	[stmt_end] [int] NOT NULL,
	[request_id] [int] NOT NULL,
	[page_resource] [varbinary](8) NULL,
	[text] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQL_TempDB_Space_Usage]    Script Date: 24-06-2022 15:35:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_TempDB_Space_Usage](
	[ServerName] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[Collection_Time] [varchar](30) NULL,
	[FileName] [nvarchar](128) NULL,
	[file_id] [smallint] NULL,
	[FilePages] [bigint] NULL,
	[File_Space_In_MB] [numeric](27, 6) NULL,
	[free_free_Pages] [bigint] NULL,
	[free_space_in_MB] [numeric](27, 6) NULL,
	[version_store_Pages] [bigint] NULL,
	[version_store_space_in_MB] [numeric](27, 6) NULL,
	[user_object_reserved_page_count] [bigint] NULL,
	[user_object_reserved_in_MB] [numeric](27, 6) NULL,
	[internal_object_reserved_page_count] [bigint] NULL,
	[internal_object_reserved_in_MB] [numeric](27, 6) NULL
) ON [PRIMARY]
GO




CREATE INDEX IX_SQL_AG_DB_State_Config_collection_time on [dbo].[SQL_AG_DB_State_Config]  (collection_time)
CREATE INDEX IX_SQL_Drive_Latency_collection_time on [dbo].[SQL_Drive_Latency] (collection_time)
CREATE INDEX IX_SQL_Memory_Grant_collection_time on [dbo].[SQL_Memory_Grant] (collection_time)
CREATE INDEX IX_SQL_Perf_CPU_Usage_collection_time on [dbo].[SQL_Perf_CPU_Usage]     (collection_time)
CREATE INDEX IX_SQL_Perf_Head_Blocker_collection_time on [dbo].[SQL_Perf_Head_Blocker]     (collection_time)
CREATE INDEX IX_SQL_Perf_Running_queries_collection_time on [dbo].[SQL_Perf_Running_queries]   (collection_time)
CREATE INDEX IX_SQL_Perf_Tempdb_Usage_collection_time on [dbo].[SQL_Perf_Tempdb_Usage]     (collection_time)
CREATE INDEX IX_SQL_Perf_Worker_Count_collection_time on [dbo].[SQL_Perf_Worker_Count]    (collection_time)
CREATE INDEX IX_SQL_Sessions_Info_collection_time on [dbo].[SQL_Sessions_Info]    (collection_time)
CREATE INDEX IX_SQL_TempDB_Space_Usage_collection_time on [dbo].[SQL_TempDB_Space_Usage]  (collection_time)