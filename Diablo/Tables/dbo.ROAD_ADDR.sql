USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROAD_ADDR](
	[관리번호] [varchar](25) NOT NULL,
	[도로명코드] [varchar](12) NOT NULL,
	[읍면동일련번호] [varchar](2) NOT NULL,
	[지하여부] [char](1) NULL,
	[건물본번] [int] NULL,
	[건물부번] [int] NULL,
	[기초구역번호] [varchar](5) NULL,
	[변경사유코드] [char](2) NULL,
	[고시일자] [varchar](8) NULL,
	[변경전도로명주소] [varchar](25) NULL,
	[상세주소부여여부] [char](1) NULL,
 CONSTRAINT [ROAD_ADDR_PK1] PRIMARY KEY CLUSTERED 
(
	[관리번호] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROAD_ADDR]  WITH CHECK ADD  CONSTRAINT [ROAD_ADDR_FK1] FOREIGN KEY([도로명코드], [읍면동일련번호])
REFERENCES [dbo].[ROAD_ADDR_CODE] ([도로명코드], [읍면동일련번호])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROAD_ADDR] CHECK CONSTRAINT [ROAD_ADDR_FK1]
GO
