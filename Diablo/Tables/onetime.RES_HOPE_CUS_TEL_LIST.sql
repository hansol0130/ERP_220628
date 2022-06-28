USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[RES_HOPE_CUS_TEL_LIST](
	[NOR_TEL] [varchar](11) NOT NULL,
 CONSTRAINT [PK_RES_HOPE_CUS_TEL_LIST] PRIMARY KEY CLUSTERED 
(
	[NOR_TEL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
