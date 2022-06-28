USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_FLT_DEPARTURE](
	[DEP_DATE] [datetime] NOT NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NOT NULL,
	[FLIGHT_NO] [varchar](4) NOT NULL,
	[AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[EST_DATE] [datetime] NULL,
	[GATE_NUMBER] [varchar](10) NULL,
	[CHECK_IN] [varchar](20) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[REMARK] [varchar](2000) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[TERMINAL_ID] [varchar](10) NULL,
 CONSTRAINT [PK_API_FLT_DEPARTURE] PRIMARY KEY CLUSTERED 
(
	[DEP_DATE] ASC,
	[AIRLINE_CODE] ASC,
	[FLIGHT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'FLIGHT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예상출발시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'EST_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게이트 번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'GATE_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크인시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'CHECK_IN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편 운항정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_FLT_DEPARTURE'
GO
