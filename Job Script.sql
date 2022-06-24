USE [msdb]
GO

/****** Object:  Job [Capture_CPU Usage]    Script Date: 24-06-2022 15:35:58 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 24-06-2022 15:35:58 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Capture_CPU Usage', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CPU Usage]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CPU Usage', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
		DECLARE @ts_now BIGINT
		SELECT @ts_now = cpu_ticks / (cpu_ticks/ms_ticks) from sys.dm_os_sys_info;
		INSERT INTO Perf_CPU_Usage
		SELECT  @@SERVERNAME as InstanceName,db_name() as DatabaseName,
				CAST(CONVERT (varchar(30), getdate(), 121)AS DATETIME) as Collection_Time,
				CAST(DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS DATETIME)  AS EventTime,
				CPUUsage_SQL,
				100 - SystemIdle - CPUUsage_SQL  AS CPUUsage_Other,
				100 - SystemIdle				 AS	CPUUsage_Total
		FROM (SELECT record.value(''(./Record/@id)[1]'', ''int'') AS Record_ID,
				record.value(''(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]'', ''int'')           AS SystemIdle,
				record.value(''(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]'', ''int'')   AS CPUUsage_SQL,
				timestamp AS timestamp
			FROM (SELECT timestamp, CONVERT(XML, record) AS record
				FROM sys.dm_os_ring_buffers WHERE ring_buffer_type = N''RING_BUFFER_SCHEDULER_MONITOR'' AND record LIKE ''%<SystemHealth>%''
				) AS x
			) AS y ORDER BY Record_ID DESC
                 option(recompile);', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every 6 hour', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=8, 
		@freq_subday_interval=6, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20220624, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'ee32ae53-cc2e-4bd7-b7a3-9ebb2cb1cb50'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Capture_Performance_queries]    Script Date: 24-06-2022 15:35:59 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 24-06-2022 15:35:59 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Capture_Performance_queries', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CPU Worker Information]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CPU Worker Information', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'	set nocount on;
		INSERT INTO dbo.SQL_Perf_Worker_Count
		SELECT      @@SERVERNAME as InstanceName, 
				db_name() as databasename, 
				CONVERT (varchar(30), getdate(), 121) as Collection_Time, 
					sum(current_tasks_count) current_tasks_count,
				sum(current_workers_count) current_workers_count,
				sum(active_workers_count) active_workers_count,
				sum(work_queue_count) work_queue_count
		FROM sys.dm_os_schedulers
		WHERE STATUS = ''Visible Online''
		option(recompile);', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Blocking Queries]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Blocking Queries', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'set nocount on;
	
	insert into dbo.SQL_Perf_Head_Blocker
	SELECT 
			@@SERVERNAME as InstanceName,db_name() as databasename,
			CONVERT (varchar(30), getdate(), 121) as Collection_Time,
				t1.resource_type AS [lock type], 
				DB_NAME(resource_database_id) AS [database],
				t1.resource_associated_entity_id AS [blk object],
				t1.request_mode AS [lock req],  -- lock requested
				t1.request_session_id AS [waiter sid], 
				t2.wait_duration_ms AS [wait time],       -- spid of waiter 
				(  SELECT substring (REPLACE (REPLACE (SUBSTRING (s1.text , (r1.statement_start_offset/2) + 1 ,
									( (CASE r1.statement_end_offset WHEN -1 THEN DATALENGTH(s1.text) ELSE r1.statement_end_offset
									END - r1.statement_start_offset)/2) + 1) , CHAR(10), '' ''), CHAR(13), '' ''), 1, 2000) AS statement_text
					FROM sys.dm_exec_requests AS r1 WITH (NOLOCK)
					CROSS APPLY sys.dm_exec_sql_text(r1.[sql_handle]) AS s1
					WHERE r1.session_id = t1.request_session_id
				) AS [waiter_stmt],					-- statement blocked 
				t2.blocking_session_id AS [blocker sid],										-- spid of blocker
				(
					SELECT [text] FROM sys.sysprocesses AS p										-- get sql for blocker
					CROSS APPLY sys.dm_exec_sql_text(p.[sql_handle]) 
					WHERE p.spid = t2.blocking_session_id
				) AS [blocker_full_text], 
				(
					SELECT substring (REPLACE (REPLACE (SUBSTRING (s1.text , (r1.stmt_start/2) + 1 ,
					( (CASE r1.stmt_end WHEN -1 THEN DATALENGTH(s1.text) ELSE r1.stmt_end
					END - r1.stmt_start)/2) + 1) , CHAR(10), '' ''), CHAR(13), '' ''), 1, 2000) AS blocker_batch 
					FROM sys.sysprocesses AS r1										-- get sql for blocker
					CROSS APPLY sys.dm_exec_sql_text(r1.[sql_handle]) s1 
					WHERE r1.spid = t2.blocking_session_id
				) AS [blocker_batch]
	FROM sys.dm_tran_locks AS t1 WITH (NOLOCK)
	INNER JOIN sys.dm_os_waiting_tasks AS t2 WITH (NOLOCK) ON t1.lock_owner_address = t2.resource_address 
	OPTION (RECOMPILE); ', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Running queries]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Running queries', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'			set nocount on;
			INSERT INTO dbo.SQL_Perf_Running_queries
			SELECT
						@@SERVERNAME InstanceName, 
						CONVERT (varchar(30), getdate(), 121) as Collection_Time,
						db_name(req.database_id) as Database_Name,
						object_name(st.objectid,st.dbid) ''ObjectName'' ,
						substring (REPLACE (REPLACE (SUBSTRING (ST.text , (req.statement_start_offset/2) + 1 ,
						( (CASE statement_end_offset WHEN -1 THEN DATALENGTH(ST.text) ELSE req.statement_end_offset
						END - req.statement_start_offset)/2) + 1) , CHAR(10), '' ''), CHAR(13), '' ''), 1, 2000) AS statement_text,
						s.client_interface_name,s.host_name,s.program_name,s.login_name,s.login_time,s.last_request_start_time,s.last_request_end_time,
						cs.auth_scheme,cs.client_net_address,cs.client_tcp_port,
						req.*						
			FROM sys.dm_exec_requests AS req
			left join sys.dm_exec_sessions s on s.session_id = req.session_id
			left join sys.dm_exec_connections cs on cs.session_id = req.session_id
			outer APPLY sys.dm_exec_sql_text(req.sql_handle) as ST
			WHERE req.session_id >50
			and req.status not in (''background'',''sleeping'')
			 and req.session_id <> @@SPID
			ORDER BY cpu_time desc
			option(recompile)', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Extra Session Queries]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Extra Session Queries', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--6 Sessions_Info
			INSERT INTO dbo.SQL_Sessions_Info
			select @@SERVERNAME as InstanceName,CONVERT (varchar(30), getdate(), 121) as Collection_Time,sp.*,ST.text
			from sys.sysprocesses sp
			outer apply sys.dm_exec_sql_text(sp.sql_handle) as ST
			where sp.spid not in (select session_id from sys.dm_exec_requests)
			and sp.status <> ''sleeping''
                  option(recompile);', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [High_memory_grant_queries]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'High_memory_grant_queries', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'		INSERT INTO  dbo.SQL_Memory_Grant
		SELECT CONVERT (varchar(30), getdate(), 121) as Collection_Time,
		--Session connection information
			s.host_name, s.program_name, s.login_name, s.client_interface_name, s.is_user_process, s.last_request_start_time, s.last_request_end_time,
		--Session data 
		  s.[session_id], s.open_transaction_count
		--Memory usage
		, r.granted_query_memory, mg.grant_time, mg.requested_memory_kb, mg.granted_memory_kb, mg.required_memory_kb, mg.used_memory_kb, mg.max_used_memory_kb     
		--Query 
		--, query_text = t.text,query_plan_xml = qp.query_plan,
		,substring (REPLACE (REPLACE (SUBSTRING (t.text , (r.statement_start_offset/2) + 1 ,
			( (CASE statement_end_offset WHEN -1 THEN DATALENGTH(t.text) ELSE r.statement_end_offset
			END - r.statement_start_offset)/2) + 1) , CHAR(10), '' ''), CHAR(13), '' ''), 1, 2000) AS statement_text
		, input_buffer = ib.event_info,  request_row_count = r.row_count, session_row_count = s.row_count
		--Session history and status
		 ,s.reads, s.writes, s.logical_reads, session_status = s.[status], request_status = r.status
		FROM sys.dm_exec_sessions s 
		LEFT OUTER JOIN sys.dm_exec_requests AS r 
			ON r.[session_id] = s.[session_id]
		LEFT OUTER JOIN sys.dm_exec_query_memory_grants AS mg 
			ON mg.[session_id] = s.[session_id]
		OUTER APPLY sys.dm_exec_sql_text (r.[sql_handle]) AS t
		OUTER APPLY sys.dm_exec_input_buffer(s.[session_id], NULL) AS ib 
		--OUTER APPLY sys.dm_exec_query_plan (r.[plan_handle]) AS qp 
		WHERE mg.granted_memory_kb > 0 and s.[session_id] <> @@spid
		ORDER BY mg.granted_memory_kb desc, mg.requested_memory_kb desc;', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [tempdb Expensive query usage]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'tempdb Expensive query usage', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert INTO dbo.SQL_Perf_Tempdb_Usage
		SELECT @@SERVERNAME as InstanceName,CONVERT (varchar(30), getdate(), 121) as Collection_Time,r.*,Sessionspace.*, TASKSPACE.*,d.log_reuse_wait,d.log_reuse_wait_desc,t2.* 
		FROM tempdb.sys.dm_exec_sessions AS t2
		LEFT JOIN tempdb.sys.dm_exec_connections AS t1  ON t1.session_id = t2.session_id         
		OUTER APPLY tempdb.sys.dm_exec_sql_text(t1.most_recent_sql_handle) AS st 
		left JOIN sys.databases d on d.database_id = t2.database_id
		outer apply (
					SELECT 
					    req.start_time
					   , cpu_time ''cpu_time_ms''
					   , object_name(st.objectid,st.dbid) ''ObjectName'' 
					   , substring
						  (REPLACE
							(REPLACE
							  (SUBSTRING
								(ST.text
								, (req.statement_start_offset/2) + 1
								, (
								   (CASE statement_end_offset
									  WHEN -1
									  THEN DATALENGTH(ST.text)  
									  ELSE req.statement_end_offset
									  END
										- req.statement_start_offset)/2) + 1)
						   , CHAR(10), '' ''), CHAR(13), '' ''), 1, 512)  AS statement_text  
					FROM tempdb.sys.dm_exec_requests AS req  
					   CROSS APPLY tempdb.sys.dm_exec_sql_text(req.sql_handle) as ST 
					   WHERE req.session_id = t2.session_id
		) r
		outer apply 
		(
			SELECT --R2.session_id,
			R1.internal_objects_alloc_page_count   + SUM(R2.internal_objects_alloc_page_count) AS session_internal_objects_alloc_page_count,
			R1.internal_objects_dealloc_page_count  + SUM(R2.internal_objects_dealloc_page_count) AS session_internal_objects_dealloc_page_count
			FROM tempdb.sys.dm_db_session_space_usage AS R1 
			LEFT JOIN tempdb.sys.dm_db_task_space_usage AS R2 ON R1.session_id = R2.session_id
			WHERE t2.session_id = R2.session_id
			GROUP BY R2.session_id, R1.internal_objects_alloc_page_count, R1.internal_objects_dealloc_page_count 
		)Sessionspace 
		outer apply
		(	
			SELECT --TASKSPACE.session_id, 
			SUM(TASKSPACE.internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
			SUM(TASKSPACE.internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
			FROM tempdb.sys.dm_db_task_space_usage TASKSPACE
			where session_id = t2.session_id 
			GROUP BY session_id 
		)TASKSPACE  
		WHERE   Sessionspace.session_internal_objects_alloc_page_count >0 AND t2.session_id <> @@SPID
            option(recompile);', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [tempdb_file_growth]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'tempdb_file_growth', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert INTO dbadmin.dbo.SQL_TempDB_Space_Usage
	SELECT @@SERVERNAME as ServerName,db_name(database_id) as DatabaseName,CONVERT (varchar(30), getdate(), 121) as Collection_Time,file_name(file_id) as FileName,file_id,
	SUM(allocated_extent_page_count) AS [FilePages], 
	(SUM(allocated_extent_page_count)*1.0/128) AS [File_Space_In_MB], 
	(SUM(unallocated_extent_page_count)) AS [free_free_Pages],
	(SUM(unallocated_extent_page_count)*1.0/128) AS [free_space_in_MB],
	(SUM(version_store_reserved_page_count)) AS [version_store_Pages],
	(SUM(version_store_reserved_page_count)*1.0/128) AS [version_store_space_in_MB],
	(SUM(user_object_reserved_page_count)) AS [user_object_reserved_page_count],
	(SUM(user_object_reserved_page_count)*1.0/128) AS [user_object_reserved_in_MB],
	(SUM(internal_object_reserved_page_count)) AS [internal_object_reserved_page_count],
	(SUM(internal_object_reserved_page_count)*1.0/128) AS [internal_object_reserved_in_MB]
	FROM tempdb.sys.dm_db_file_space_usage
	group by database_id,file_id
      option(recompile);', 
		@database_name=N'tempdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [AlwaysOn Stats]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'AlwaysOn Stats', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'set nocount on; 
	INSERT INTO dbo.SQL_AG_DB_State_Config
	select @@SERVERNAME as ServerName, CAST(CONVERT (varchar(30), getdate(), 121)AS DATETIME) as Collection_Time,
	database_name=cast(drcs.database_name as varchar(30)), 
	drs.database_id,
	drs.group_id,
	drs.replica_id,
	drs.is_local,
	drcs.is_failover_ready,
	drcs.is_pending_secondary_suspend,
	drcs.is_database_joined,
	drs.is_suspended,
	drs.is_commit_participant,
	suspend_reason_desc=cast(drs.suspend_reason_desc as varchar(30)),
	synchronization_state_desc=cast(drs.synchronization_state_desc as varchar(30)),
	synchronization_health_desc=cast(drs.synchronization_health_desc as varchar(30)),
	database_state_desc=cast(drs.database_state_desc as varchar(30)),
	drs.last_sent_lsn,
	drs.last_sent_time,
	drs.last_received_lsn,
	drs.last_received_time,
	drs.last_hardened_lsn,
	drs.last_hardened_time,
	drs.last_redone_lsn,
	drs.last_redone_time,
	drs.log_send_queue_size,
	drs.log_send_rate,
	drs.redo_queue_size,
	drs.redo_rate,
	drs.filestream_send_rate,
	drs.end_of_log_lsn,
	drs.last_commit_lsn,
	drs.last_commit_time,
	drs.low_water_mark_for_ghosts,
	drs.recovery_lsn,
	drs.truncation_lsn,
	pr.file_id,
	pr.error_type,
	pr.page_id,
	pr.page_status,
	pr.modification_time 
	from sys.dm_hadr_database_replica_cluster_states drcs 
	join sys.dm_hadr_database_replica_states drs on drcs.replica_id=drs.replica_id and drcs.group_database_id=drs.group_database_id 
      left outer join sys.dm_hadr_auto_page_repair pr on drs.database_id=pr.database_id ', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [File Level Latency]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'File Level Latency', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'		insert 	into dbo.SQL_Drive_Latency
		SELECT @@SERVERNAME AS servername, CAST(CONVERT (varchar(30), getdate(), 121)AS DATETIME) as Collection_Time,tab.[Drive], tab.volume_mount_point AS [Volume Mount Point], 
		CASE 
			WHEN num_of_reads = 0 THEN 0 
			ELSE (io_stall_read_ms/num_of_reads) 
		END AS [Read Latency],
		CASE 
			WHEN num_of_writes = 0 THEN 0 
			ELSE (io_stall_write_ms/num_of_writes) 
		END AS [Write Latency],
		CASE 
			WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
			ELSE (io_stall/(num_of_reads + num_of_writes)) 
		END AS [Overall Latency],
		CASE 
			WHEN num_of_reads = 0 THEN 0 
			ELSE (num_of_bytes_read/num_of_reads) 
		END AS [Avg Bytes/Read],
		CASE 
			WHEN num_of_writes = 0 THEN 0 
			ELSE (num_of_bytes_written/num_of_writes) 
		END AS [Avg Bytes/Write],
		CASE 
			WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
			ELSE ((num_of_bytes_read + num_of_bytes_written)/(num_of_reads + num_of_writes)) 
		END AS [Avg Bytes/Transfer]
	FROM (SELECT LEFT(UPPER(mf.physical_name), 2) AS Drive, SUM(num_of_reads) AS num_of_reads,
					SUM(io_stall_read_ms) AS io_stall_read_ms, SUM(num_of_writes) AS num_of_writes,
					SUM(io_stall_write_ms) AS io_stall_write_ms, SUM(num_of_bytes_read) AS num_of_bytes_read,
					SUM(num_of_bytes_written) AS num_of_bytes_written, SUM(io_stall) AS io_stall, vs.volume_mount_point 
			FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
			INNER JOIN sys.master_files AS mf WITH (NOLOCK)
			ON vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id
			CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.[file_id]) AS vs 
			GROUP BY LEFT(UPPER(mf.physical_name), 2), vs.volume_mount_point) AS tab
	ORDER BY [Overall Latency] OPTION (RECOMPILE); ', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'every 5 second', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220624, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'5ef5caca-2e31-4549-88fe-3642d92559e2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Purge Performance Data]    Script Date: 24-06-2022 15:35:59 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 24-06-2022 15:35:59 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Purge Performance Data', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge Data]    Script Date: 24-06-2022 15:35:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge Data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DELETE FROM  [dbo].[SQL_AG_DB_State_Config]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Drive_Latency]    where collection_time < getdate()-7; 
DELETE FROM  [dbo].[SQL_Memory_Grant]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Perf_CPU_Usage]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Perf_Head_Blocker]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Perf_Running_queries]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Perf_Tempdb_Usage]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Perf_Worker_Count]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_Sessions_Info]    where collection_time < getdate()-7;
DELETE FROM  [dbo].[SQL_TempDB_Space_Usage]    where collection_time < getdate()-7;', 
		@database_name=N'dbadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220624, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'46593294-74c4-4643-8d06-c07cb7168dd8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


