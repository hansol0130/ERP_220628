USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_CONSULT](
	[CON_NO] [int] IDENTITY(1,1) NOT NULL,
	[EDT_CODE] [char](7) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[HOPE_TIME] [datetime] NULL,
	[HOPE_PRICE] [varchar](20) NULL,
	[EXP_COUNT] [int] NULL,
	[CONTACT_YN] [char](1) NULL,
	[CONTACT_TIME] [datetime] NULL,
	[MNG_CODE] [char](7) NOT NULL,
	[RESERVE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[ETC] [nvarchar](max) NULL,
	[CUS_NO] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[CON_GRADE] [int] NULL,
 CONSTRAINT [PK_CUS_CONSULT] PRIMARY KEY CLUSTERED 
(
	[CON_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_CONSULT] ADD  CONSTRAINT [DF_CUS_CONSULT_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[CUS_CONSULT] ADD  CONSTRAINT [DF_CUS_CONSULT_CON_GRADE]  DEFAULT ((1)) FOR [CON_GRADE]
GO
ALTER TABLE [dbo].[CUS_CONSULT]  WITH CHECK ADD  CONSTRAINT [R_153] FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_CUSTOMER_damo] ([CUS_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUS_CONSULT] CHECK CONSTRAINT [R_153]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비선호 : 0, 보통 : 1, 선호 : 2, 높은선호 : 3 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CONSULT', @level2type=N'COLUMN',@level2name=N'CON_GRADE'
GO
