SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DEVICE](
	[DEV_ID] [int] IDENTITY(1,1) NOT NULL,
	[DEV_MOTE] [varchar](20) NULL,
	[PROJ_ID] [int] NULL,
	[ENT_ID] [int] NULL,
	[DEV_NETKEY] [varchar](100) NULL,
	[DEV_APPKEY] [varchar](100) NULL,
	[DEV_COMMENTS] [varchar](2000) NULL,
	[USER_ID] [int] NULL,
	[GATEWAY_IP] [varchar](20) NULL,
	[DEV_BARCODE] [varchar](15) NULL,
	[DEV_UNIT_FACTOR] [float] NULL CONSTRAINT [DF_DEVICE_DEV_UNIT_FACTOR]  DEFAULT ((1)),
	[DEV_DESCR] [varchar](200) NULL,
	[DEVT_ID] [int] NULL,
	[createdAt] [datetime2](7) NOT NULL DEFAULT (getdate()),
	[updatedAt] [datetime2](7) NULL
 CONSTRAINT [PK_DEVICES] PRIMARY KEY CLUSTERED 
(
	[DEV_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DEVICE_TYPE](
	[DEVT_ID] [int] NOT NULL,
	[DEVT_DESCR] [varchar](200) NULL,
 CONSTRAINT [PK_DEVICE_TYPE] PRIMARY KEY CLUSTERED 
(
	[DEVT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ENTITY](
	[ENT_ID] [int] IDENTITY(1,1) NOT NULL,
	[ENTT_ID] [int] NOT NULL,
	[ENT_TAG] [varchar](10) NULL,
	[ENT_CODE] [int] NULL,
	[ENT_DESCR] [varchar](200) NULL,
	[ENT_ADDRESS] [varchar](255) NULL,
	[ENT_LAT] [float] NULL,
	[ENT_LNG] [float] NULL,
	[PROJ_ID] [int] NULL,
	[ENT_HEIGHT] [int] NULL,
	[createdAt] [datetime2](7) NOT NULL DEFAULT (getdate()),
	[updatedAt] [datetime2](7) NULL,
 CONSTRAINT [PK_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ENTITY_TYPE](
	[ENTT_ID] [int] IDENTITY(1,1) NOT NULL,
	[ENTT_DESCR] [varchar](100) NULL,
 CONSTRAINT [PK_ENTITY_TYPE] PRIMARY KEY CLUSTERED 
(
	[ENTT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ENTRIES](
	-- devices info saved here
 CONSTRAINT [PK_ENTRIES] PRIMARY KEY CLUSTERED 
(
	[ENTR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [LASTSTATUS](
	-- last devices info saved here
 CONSTRAINT [PK_LASTSTATUS] PRIMARY KEY CLUSTERED 
(
	[DEV_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [logs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NOT NULL,
	[description] [varchar](max) NOT NULL,
	[createdAt] [datetime2](1) NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK__logs__3213E83F65316709] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PROJECT](
	[PROJ_ID] [int] IDENTITY(1,1) NOT NULL,
	[PROJ_NAME] [varchar](50) NULL,
	[PROJ_DESCR] [varchar](500) NULL,
	[PROJ_LOGO] [varchar](255) NULL,
	[createdAt] [datetime2](7) NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_PROJECT] PRIMARY KEY CLUSTERED 
(
	[PROJ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](255) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[type] [int] NOT NULL,
	[email] [varchar](255) NULL,
	[phone] [varchar](255) NULL,
	[name] [varchar](255) NOT NULL,
	[project] [int] NOT NULL,
	[createdAt] [datetime2](7) NOT NULL DEFAULT (getdate()),
	[updatedAt] [datetime2](0) NULL,
 CONSTRAINT [PK__users__3213E83F236FF31A] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [DEVICE]  WITH CHECK ADD  CONSTRAINT [FK_DEVICE_DEVICE_TYPE] FOREIGN KEY([DEVT_ID])
REFERENCES [DEVICE_TYPE] ([DEVT_ID])
GO
ALTER TABLE [DEVICE] CHECK CONSTRAINT [FK_DEVICE_DEVICE_TYPE]
GO
ALTER TABLE [DEVICE]  WITH CHECK ADD  CONSTRAINT [FK_DEVICE_ENTITY] FOREIGN KEY([ENT_ID])
REFERENCES [ENTITY] ([ENT_ID])
GO
ALTER TABLE [DEVICE] CHECK CONSTRAINT [FK_DEVICE_ENTITY]
GO
ALTER TABLE [DEVICE]  WITH CHECK ADD  CONSTRAINT [FK_DEVICE_PROJECT] FOREIGN KEY([PROJ_ID])
REFERENCES [PROJECT] ([PROJ_ID])
GO
ALTER TABLE [DEVICE] CHECK CONSTRAINT [FK_DEVICE_PROJECT]
GO
ALTER TABLE [DEVICE]  WITH CHECK ADD  CONSTRAINT [FK_DEVICE_USER] FOREIGN KEY([USER_ID])
REFERENCES [users] ([id])
GO
ALTER TABLE [DEVICE] CHECK CONSTRAINT [FK_DEVICE_USER]
GO
ALTER TABLE [ENTITY]  WITH CHECK ADD  CONSTRAINT [FK_ENTITY_ENTITY_TYPE] FOREIGN KEY([ENTT_ID])
REFERENCES [ENTITY_TYPE] ([ENTT_ID])
GO
ALTER TABLE [ENTITY] CHECK CONSTRAINT [FK_ENTITY_ENTITY_TYPE]
GO
ALTER TABLE [ENTITY]  WITH CHECK ADD  CONSTRAINT [FK_ENTITY_PROJECT] FOREIGN KEY([PROJ_ID])
REFERENCES [PROJECT] ([PROJ_ID])
GO
ALTER TABLE [ENTITY] CHECK CONSTRAINT [FK_ENTITY_PROJECT]
GO
ALTER TABLE [ENTRIES]  WITH CHECK ADD  CONSTRAINT [FK_ENTRIES_DEVICE] FOREIGN KEY([DEV_ID])
REFERENCES [DEVICE] ([DEV_ID])
GO
ALTER TABLE [ENTRIES] CHECK CONSTRAINT [FK_ENTRIES_DEVICE]
GO
ALTER TABLE [logs]  WITH CHECK ADD  CONSTRAINT [user_fk] FOREIGN KEY([userid])
REFERENCES [users] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [logs] CHECK CONSTRAINT [user_fk]
GO
ALTER TABLE [users]  WITH CHECK ADD  CONSTRAINT [fk_user_project] FOREIGN KEY([project])
REFERENCES [PROJECT] ([PROJ_ID])
GO
ALTER TABLE [users] CHECK CONSTRAINT [fk_user_project]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [api_getDevicesList]
	@project int
	
AS 

BEGIN
	SELECT	DEV_ID as id,
			DEV_BARCODE as barcode,
	FROM dbo.DEVICE
	WHERE PROJ_ID = @project
	ORDER BY DEV_ID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [api_getLastValue]
	@id int
	
AS 

BEGIN
	SELECT	convert(decimal(10,2),(ls.LS_COUNTER*dv.DEV_UNIT_FACTOR)/10) as value,
			ls.LS_DATE as date,
			ls.LS_VALVE  as status
	FROM dbo.LASTSTATUS ls
	JOIN dbo.DEVICE dv ON dv.DEV_ID = ls.DEV_ID
	WHERE ls.DEV_ID = @id
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [api_getLastValues]
	@project int
	
AS 

BEGIN
	SELECT	dv.DEV_ID as id,
			convert(decimal(10,2),(ls.LS_COUNTER*dv.DEV_UNIT_FACTOR)/10) as value,
			ls.LS_DATE as date,
			ls.LS_VALVE  as status
	FROM dbo.LASTSTATUS ls
	JOIN dbo.DEVICE dv ON dv.DEV_ID = ls.DEV_ID
	WHERE dv.PROJ_ID = 7
	ORDER BY dv.DEV_ID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [api_getValues]
	@id int,
	@from datetime,
	@to datetime
	
AS

BEGIN
	select @to=dateadd(day,1,@to)
	
	;with cte as (
		select	en1.ENTR_DATE as date,
				convert(decimal(10,2),(cast(en1.ENTR_COUNTER as float)*DEV_UNIT_FACTOR)/10) as value,
				row_number() over (partition by dv1.DEV_MOTE,cast(en1.ENTR_DATE as date) order by en1.ENTR_COUNTER  desc) as rn
		from entries en1
		join device dv1 on dv1.DEV_ID = en1.DEV_ID
		where en1.DEV_ID = @id
		and en1.ENTR_DATE between @from and @to
	)
	select date,value from cte
	where rn=1
	order by date desc
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [usp_updateEntityLocation]
	@device int,
	@lat float,
	@lng float
	
AS 

begin
	declare @entity int;
	select @entity=dv.ENT_ID from dbo.DEVICE dv where dv.DEV_ID = @device
	
	if @entity is not null
	begin
		update dbo.ENTITY 
		set	ENT_LAT = @lat,
			ENT_LNG = @lng,
			updatedAt = getdate()
		where ENT_ID = @entity
	end
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_addDevice]
	@project int,
	@type int,
	@entity int,
	@barcode varchar(15),
	@mote varchar(20),
	@ip varchar(20)

AS

begin
	insert into dbo.DEVICE(DEVT_ID,DEV_MOTE,PROJ_ID,ENT_ID,GATEWAY_IP,DEV_BARCODE)
	values(@type,@mote,@project,@entity,@ip,@barcode)
	
	select @@identity as id
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_addEntity]
	@type int,
	@title varchar(200),
	@address varchar(255),
	@lat float,
	@lng float,
	@project int,
	@height int
	
AS 

begin
	declare @tag int = (select coalesce(max(ENT_CODE),0) from dbo.ENTITY where PROJ_ID = 12)+1
	
	insert into dbo.ENTITY(ENTT_ID,ENT_TAG,ENT_CODE,ENT_DESCR,ENT_ADDRESS,ENT_LAT,ENT_LNG,PROJ_ID,ENT_HEIGHT)
	values(@type,@tag,@tag,@title,@address,@lat,@lng,@project,@height)
	
	select @@identity as id
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_checkUser]
	@username varchar(255),
	@password varchar(255)
	
AS

begin
	select	us.id,
			us.name,
			us.type,
			us.project,
			pj.PROJ_NAME as title,
			pj.PROJ_DESCR as description,
			pj.PROJ_LOGO as logo
	from dbo.users us
	join dbo.PROJECT pj on pj.PROJ_ID = us.project
	where us.username = @username
	and us.password = @password
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_countDevices]
	@project int
	
AS 

begin
	select dv.DEVT_ID as type, count(dv.DEV_ID) as count
	from dbo.DEVICE dv
	where dv.PROJ_ID = @project
	group by dv.DEVT_ID
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_countEntities]
	@project int
	
AS 

begin
	select en.ENTT_ID as type, count(en.ENT_ID) as count
	from dbo.ENTITY en
	where en.PROJ_ID = @project
	group by en.ENTT_ID
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_deleteDevice]
	@id int
	
AS 

begin
	delete from dbo.DEVICE
	where DEV_ID = @id
	
	select @@rowcount as rows
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_deleteEntity]
	@id int
	
AS 

begin
	delete from dbo.ENTITY 
	where ENT_ID = @id
	
	select @@rowcount as rows
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_deleteUser]
	@id int
AS
	begin
		delete from dbo.users
		where id = @id

		select @id as 'deleted'
	end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getAllDevices]
	@project int
	
AS

begin
	select	dv.DEV_ID as id,
			dv.DEVT_ID as type,
			dv.ENT_ID as entity,
			dv.DEV_BARCODE as barcode,
			dv.DEV_MOTE as mote,
			dv.GATEWAY_IP as ip,
			dv.DEV_DESCR as description,
			dv.DEV_COMMENTS as comments
	from dbo.DEVICE dv
	where dv.PROJ_ID = @project
	order by dv.DEV_ID
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getDevices]
	@entity int
	
AS

begin
	declare @typeID int
	select @typeID = ENTT_ID from dbo.ENTITY where ENT_ID = @entity
	
	select	ls.DEV_ID as id,
			COALESCE(dv.DEV_DESCR,'-') as name,
			dv.DEVT_ID as type,
			dv.DEV_MOTE as code,
			dv.DEV_BARCODE as barcode,
			convert(decimal(10,2),((ls.LS_FREQ+ls.LS_SEQNO)/2)/dv.DEV_UNIT_FACTOR) as value,
			ls.LS_DATE as date,
			ls.LS_MVOLT as battery,
			ls.LS_TEMPER as temperature,
			ls.LS_VALVE  as status
	from dbo.DEVICE dv
	left outer join dbo.LASTSTATUS ls on dv.DEV_ID = ls.DEV_ID
	where dv.ENT_ID = @entity
	and dv.DEVT_ID = 20
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getDeviceStatusHistory]
	@device int,
	@dateFrom datetime2,
	@dateTo datetime2
	
AS 

begin
	select	en.ENTR_DATE as date,
			en.ENTR_VALVE as status
	from entries en
	where en.DEV_ID = @device
	and cast(en.entr_date as date) between @dateFrom and @dateTo
	order by en.ENTR_DATE desc
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getDumpsterDeviceHistory]
	@id int
	
AS 

begin
	;with cte as (
		select	en.entr_id as id,
				en.entr_date as date,
				(1 - (((en.ENTR_FREQ+en.ENTR_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/ent.ENT_HEIGHT)*100 as value,
				row_number() over (partition by cast(en.entr_date as date) order by en.entr_date desc) as rn
		from dbo.entries en
		join dbo.device dv on dv.DEV_ID = en.DEV_ID
		join dbo.ENTITY ent on ent.ENT_ID = dv.ENT_ID
		where dv.dev_id = @id
		and en.ENTR_DATE > dateadd(month, -1, getdate())
	)
	select top 30 id,date,convert(decimal(10,2),(value)) as value from cte where rn=1 order by date
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getDumpsterDeviceLastValues]
	@id int
	
AS 

begin
	;with cte as (
		select	en.entr_id as id,
				en.entr_date as date,
				(1 - (((en.ENTR_FREQ+en.ENTR_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/ent.ENT_HEIGHT)*100 as value,
				row_number() over (partition by cast(en.entr_date as date) order by en.entr_date desc) as rn
		from dbo.entries en
		join dbo.device dv on dv.DEV_ID = en.DEV_ID
		join dbo.ENTITY ent on ent.ENT_ID = dv.ENT_ID
		where dv.dev_id = @id
	)
	
	select top 7 date,diff as value
	from	(
		select row_number() over (order by date) as rn2,date,value,value - coalesce(lag(value) over (order by date), 0) as diff
		from cte
		where rn = 1
	) t
	where rn2 > 1
	order by date desc
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getEntities]
	@project int
	
AS

begin
	select	en.ENT_ID as id,
			en.ENTT_ID as type,
			en.ENT_DESCR as description,
			en.ENT_ADDRESS as address,
			en.ENT_LAT as lat,
			en.ENT_LNG as lng,
			en.ENT_HEIGHT as height,
	from dbo.ENTITY en
	where en.PROJ_ID = @project
end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getFullDumpEntities]
	@project int,
	@rate int
	
AS 

begin
	with res as(
		select en.ENT_ID as ent,
				dv.DEV_ID as dev,
				(1 - (((ls.LS_FREQ+ls.LS_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/en.ENT_HEIGHT)*100 as value
		from dbo.ENTITY en
		join dbo.DEVICE dv on dv.ENT_ID = en.ENT_ID
		join dbo.LASTSTATUS ls on ls.DEV_ID = dv.DEV_ID 
		where en.PROJ_ID = @project
	)
	select distinct ent as id from res where value > @rate
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getLogs]
	@user int
	
AS
	begin

		select *
		from logs
		where userid = @user

	end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getProjectInfo]
	@project int
	
AS 

begin
	declare @entities int, @devices int, @users int;

	select @entities = count(en.ENT_ID) from dbo.ENTITY en where en.PROJ_ID = @project
	select @devices = count(dv.DEV_ID) from dbo.DEVICE dv where dv.PROJ_ID = @project
	select @users = count(us.id) from dbo.users us where us.project = @project
	
	select @entities as entities, @devices as devices, @users as users
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_getUsers]
	@project int
	
AS

begin
	select *
	from users us
	where us.project = @project
	order by us.id
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_insertLog]
	@user int,
	@description varchar(MAX)
	
AS
	begin

		insert into dbo.logs (
			userid,
			description
		)
		values (
			@user,
			@description
		)
	end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_insertUser]
	@username varchar(255),
	@password varchar(255),
	@type int,
	@email varchar(255),
	@phone varchar(255),
	@name varchar(255),
	@project int
	
AS

begin
	insert into dbo.users (username,password,type,email,phone,name,project)
	values (@username,@password,@type,@email,@phone,@name,@project)

	select @@identity as 'inserted'
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_reportValues]
	@ids varchar(max),
	@dateFrom datetime2(7),
	@dateTo datetime2(7),
	@project int
	
AS

begin
	select @dateto=dateadd(day,1,@dateto)
	
	if(@ids=',,')
	begin
		;with cte as (
			select	en.entr_date as date,
					dv.dev_mote as id,
					ent.ent_descr as description,
					dv.DEVT_ID as type,
					iif((1 - (((en.ENTR_FREQ+en.ENTR_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/ent.ENT_HEIGHT)<0,0,(1 - (((en.ENTR_FREQ+en.ENTR_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/ent.ENT_HEIGHT)*100) as value,
					row_number() over (partition by dv.dev_mote,cast(en.entr_date as date) order by en.ENTR_FREQ desc,en.entr_date desc) as rn
			from entries en
			join device dv on dv.dev_id = en.dev_id
			join entity ent on ent.ent_id = dv.ent_id
			where dv.DEVT_ID = 20
			and dv.PROJ_ID = @project
			and en.entr_date between @dateFrom and @dateTo
			and en.ENTR_FREQ is not null
			and en.ENTR_SEQNO is not null
		)
		select date,id,description,type,value from cte
		where rn=1
		order by date,id asc
	end
	else
	begin
		;with cte as (
			select	en.entr_date as date,
					dv.dev_mote as id,
					ent.ent_descr as description,
					dv.DEVT_ID as type,
					iif((1 - (((en.ENTR_FREQ+en.ENTR_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/ent.ENT_HEIGHT)<0,0,(1 - (((en.ENTR_FREQ+en.ENTR_SEQNO)/2)/dv.DEV_UNIT_FACTOR)/ent.ENT_HEIGHT)*100) as value,
					row_number() over (partition by dv.dev_mote,cast(en.entr_date as date) order by en.entr_counter desc,en.entr_date desc) as rn
			from entries en
			join device dv on dv.dev_id = en.dev_id
			join entity ent on ent.ent_id = dv.ent_id
			where dv.DEVT_ID = 20
			and charindex(',' + CAST(en.DEV_ID as nvarchar(20)) + ',', @ids) > 0
			and en.entr_date between @dateFrom and @dateTo
			and en.ENTR_FREQ is not null
			and en.ENTR_SEQNO is not null
		)
		select date,id,description,type,value from cte
		where rn=1
		order by date,id asc
	end
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_updateDevice]
	@id int,
	@type int,
	@entity int = NULL,
	@ip varchar(20) = NULL,
	@barcode varchar(15) = NULL,
	@mote varchar(20) = NULL,
	@descr varchar(200) = NULL,
	@comments varchar(2000) = NULL

AS

begin
	update dbo.DEVICE
	set	DEVT_ID = @type,
		ENT_ID = @entity,
		GATEWAY_IP = @ip,
		DEV_BARCODE = @barcode,
		DEV_MOTE = @mote,
		DEV_DESCR = @descr,
		DEV_COMMENTS = @comments,
		updatedAt = getdate()
	where DEV_ID = @id
	
	select @@rowcount as rows
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_updateEntity]
	@id int,
	@type int,
	@title varchar(200),
	@address varchar(255),
	@lat float,
	@lng float,
	@height int

AS 

begin
	update dbo.ENTITY
	set	ENTT_ID = @type,
		ENT_DESCR = @title,
		ENT_ADDRESS = @address,
		ENT_LAT = @lat,
		ENT_LNG = @lng,
		ENT_HEIGHT = @height,
		updatedAt = getdate()
	where ENT_ID = @id
	
	select @@rowcount as rows
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_updateUser]
	@id int,
	@username varchar(255),
	@password varchar(255),
	@type int,
	@email varchar(255),
	@phone varchar(255),
	@name varchar(255)
	
AS
	begin

		update dbo.users
		set
			username = @username,
			password = @password,
			type = @type,
			email = @email,
			phone = @phone,
			name = @name,
			updatedAt = getdate()
		where id = @id

		select @id as 'updated'

	end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web_wideSearch]
	@project int,
	@part varchar(100) = ''
	
AS

begin
	select	dv.dev_id as id,
			dv.dev_mote as mote,
			dv.dev_barcode as barcode,
			en.ent_id as entity,
			en.ent_address as address
	from dbo.DEVICE dv
	join dbo.ENTITY en on en.ent_id = dv.ent_id
	where dv.proj_id = @project
	and	(upper(en.ent_descr) like '%'+upper(@part)+'%' COLLATE SQL_Latin1_General_CP1253_CI_AI
	or upper(en.ent_address) like '%'+upper(@part)+'%' COLLATE SQL_Latin1_General_CP1253_CI_AI
	or upper(dv.dev_mote) like '%'+upper(@part)+'%' COLLATE SQL_Latin1_General_CP1253_CI_AI
	or upper(dv.dev_barcode) like '%'+upper(@part)+'%' COLLATE SQL_Latin1_General_CP1253_CI_AI)
	order by dv.ent_id
end
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'entity height in cm (for value as percentage !?dumpsters)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ENTITY', @level2type=N'COLUMN',@level2name=N'ENT_HEIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Altitude' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ENTRIES', @level2type=N'COLUMN',@level2name=N'ENTR_ALT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0-admin, 1-powerUser, 2-user/tech' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'users', @level2type=N'COLUMN',@level2name=N'type'
GO