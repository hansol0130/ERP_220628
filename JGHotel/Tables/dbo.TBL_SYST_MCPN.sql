USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_SYST_MCPN](
	[MCPN_CODE] [varchar](6) NOT NULL,
	[MCPN_NAME] [varchar](20) NULL,
	[MCPN_GUBUN] [char](1) NULL,
	[POST_NO1] [varchar](3) NULL,
	[POST_NO2] [varchar](3) NULL,
	[ADDR1] [varchar](100) NULL,
	[ADDR2] [varchar](100) NULL,
	[TEL_NO] [varchar](20) NULL,
	[REG_ID] [varchar](9) NULL,
	[REG_DATE] [datetime] NULL,
	[UPD_ID] [varchar](9) NULL,
	[UPD_DATE] [datetime] NULL,
	[BASE_CODE] [varchar](6) NULL,
	[AGENT_CD] [varchar](3) NULL,
	[CONTACT_TEL] [varchar](20) NULL,
	[CONTACT_FAX] [varchar](20) NULL,
	[BANK_NAME] [varchar](20) NULL,
	[BANK_NO] [varchar](30) NULL,
	[BANK_OWNERNAME] [varchar](30) NULL,
	[COM_GUBUN] [varchar](5) NULL,
	[MCPN_SORT_ORDER] [int] NULL,
	[MCPN_COM_RATE] [decimal](16, 2) NULL,
 CONSTRAINT [PK_TBL_SYST_MCPN] PRIMARY KEY CLUSTERED 
(
	[MCPN_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
