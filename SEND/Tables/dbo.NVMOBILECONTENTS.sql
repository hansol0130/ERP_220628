USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVMOBILECONTENTS](
	[CONTS_NO] [numeric](8, 0) NOT NULL,
	[USER_ID] [varchar](15) NULL,
	[CONTS_NM] [varchar](50) NULL,
	[CONTS_DESC] [varchar](100) NULL,
	[FILE_PATH] [varchar](250) NULL,
	[FILE_NAME] [varchar](100) NULL,
	[IMAGE_URL] [varchar](500) NULL,
	[DETOUR_FILE_PATH] [varchar](250) NULL,
	[DETOUR_FILE_NAME] [varchar](100) NULL,
	[DETOUR_PREVIEW_PATH] [varchar](250) NULL,
	[DETOUR_PREVIEW_NAME] [varchar](100) NULL,
	[FILE_TYPE] [char](1) NULL,
	[CREATE_DT] [char](8) NULL,
	[CREATE_TM] [char](6) NULL,
	[AUTH_TYPE] [char](1) NULL,
	[TAG_NO] [numeric](10, 0) NULL,
	[CONTS_TXT] [varchar](4000) NULL,
	[FILE_PREVIEW_PATH] [varchar](250) NULL,
	[FILE_PREVIEW_NAME] [varchar](50) NULL,
	[GRP_CD] [varchar](12) NULL,
	[FILE_SIZE] [numeric](15, 0) NULL,
	[KAKAO_SENDER_KEY] [varchar](40) NULL,
	[KAKAO_TMPL_CD] [varchar](30) NULL,
	[KAKAO_TMPL_STATUS] [char](1) NULL,
	[KAKAO_INSP_STATUS] [varchar](3) NULL,
	[USE_YN] [char](1) NOT NULL,
	[CATEGORY_CD] [varchar](12) NULL,
 CONSTRAINT [PK_NVMOBILECONTENTS] PRIMARY KEY CLUSTERED 
(
	[CONTS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVMOBILECONTENTS] ADD  DEFAULT ('Y') FOR [USE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'S:중단, A:정상, R:대기(발송전)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NVMOBILECONTENTS', @level2type=N'COLUMN',@level2name=N'KAKAO_TMPL_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'REG:등록, REQ:검수요청, REJ:반려, APR:승인' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NVMOBILECONTENTS', @level2type=N'COLUMN',@level2name=N'KAKAO_INSP_STATUS'
GO
