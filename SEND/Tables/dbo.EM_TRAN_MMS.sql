USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EM_TRAN_MMS](
	[mms_seq] [int] NOT NULL,
	[file_cnt] [int] NOT NULL,
	[build_yn] [char](1) NULL,
	[mms_body] [varchar](2000) NULL,
	[mms_subject] [varchar](40) NULL,
	[file_type1] [varchar](3) NULL,
	[file_type2] [varchar](3) NULL,
	[file_type3] [varchar](3) NULL,
	[file_type4] [varchar](3) NULL,
	[file_type5] [varchar](3) NULL,
	[file_name1] [varchar](100) NULL,
	[file_name2] [varchar](100) NULL,
	[file_name3] [varchar](100) NULL,
	[file_name4] [varchar](100) NULL,
	[file_name5] [varchar](100) NULL,
	[service_dep1] [varchar](3) NULL,
	[service_dep2] [varchar](3) NULL,
	[service_dep3] [varchar](3) NULL,
	[service_dep4] [varchar](3) NULL,
	[service_dep5] [varchar](3) NULL,
	[skn_file_name] [varchar](255) NULL,
 CONSTRAINT [pk_em_tran_mms ] PRIMARY KEY CLUSTERED 
(
	[mms_seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
