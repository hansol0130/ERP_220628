USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[m_tgcorp_tmp_tb](
	[serial] [int] IDENTITY(1,1) NOT NULL,
	[mxid] [varchar](32) NOT NULL,
	[mxissueno] [varchar](32) NOT NULL,
	[mxissuedate] [char](14) NOT NULL,
	[mstr] [varchar](1024) NULL,
	[cccode] [char](2) NULL,
	[amount] [int] NOT NULL,
	[installment] [char](2) NULL,
	[replycode] [char](8) NOT NULL,
	[replymessage] [varchar](1024) NULL,
	[mxhash] [varchar](32) NOT NULL,
	[senderip] [varchar](32) NULL,
	[etc1] [varchar](32) NULL,
	[etc2] [varchar](32) NULL,
	[etc3] [varchar](32) NULL,
	[updatedate] [datetime] NULL,
	[sdate] [varchar](8) NULL,
	[csdate] [varchar](8) NULL,
	[samount] [int] NULL,
	[csamount] [int] NULL,
 CONSTRAINT [m_tgcorp_tmp_pk] PRIMARY KEY CLUSTERED 
(
	[mxissueno] ASC,
	[mxissuedate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [m_tgcorp_tmp_uk] UNIQUE NONCLUSTERED 
(
	[serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[m_tgcorp_tmp_tb] ADD  DEFAULT ((0)) FOR [amount]
GO
