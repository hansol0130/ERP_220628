USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_AIR_DETAIL](
	[AIR_PRO_TYPE] [char](1) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[AIR_GDS] [dbo].[AIR_GDS] NULL,
	[PNR_CODE1] [varchar](20) NULL,
	[PNR_CODE2] [varchar](20) NULL,
	[OPEN_YN] [char](1) NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[ARR_FARE_CODE] [dbo].[FARE_CODE] NULL,
	[FARE_CODE] [dbo].[FARE_CODE] NULL,
	[ADT_PRICE] [money] NULL,
	[CHD_PRICE] [money] NULL,
	[INF_PRICE] [money] NULL,
	[TTL_DATE] [datetime] NULL,
	[INTER_YN] [char](1) NULL,
	[ADT_TAX] [money] NULL,
	[CHD_TAX] [money] NULL,
	[INF_TAX] [money] NULL,
	[PNR_REMARK] [varchar](20) NULL,
	[PNR_MODIFY_DATE] [datetime] NULL,
	[ISSUE_DATE] [datetime] NULL,
	[AUTO_ISSUE_YN] [char](1) NULL,
	[AUTO_ISSUE_DATE] [datetime] NULL,
	[AUTO_SUCC_YN] [char](1) NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[BKG_CLASS] [varchar](20) NULL,
	[DEP_DEP_DATE] [datetime] NULL,
	[DEP_ARR_DATE] [datetime] NULL,
	[DEP_DEP_TIME] [char](5) NULL,
	[DEP_ARR_TIME] [char](5) NULL,
	[ARR_DEP_TIME] [char](5) NULL,
	[DEP_DEP_AIRPORT_CODE] [char](3) NULL,
	[DEP_ARR_AIRPORT_CODE] [char](3) NULL,
	[ARR_DEP_DATE] [datetime] NULL,
	[ARR_ARR_DATE] [datetime] NULL,
	[ARR_ARR_TIME] [char](5) NULL,
	[ARR_DEP_AIRPORT_CODE] [char](3) NULL,
	[ARR_ARR_AIRPORT_CODE] [char](3) NULL,
	[FARE_SEAT_TYPE] [int] NULL,
	[FARE_ID_KEY] [varchar](400) NULL,
	[FARE_KEY] [varchar](200) NULL,
	[ROUTE_ID_NBR] [varchar](200) NULL,
	[ROUTING] [varchar](100) NULL,
	[ROUTING_TYPE] [int] NULL,
	[STAY_ADDRESS] [varchar](100) NULL,
	[NOR_PRICE] [int] NULL,
	[FARE_XML] [varchar](max) NULL,
	[RULE_XML] [varchar](max) NULL,
	[AIRLINE_CODE2] [dbo].[AIRLINE_CODE] NULL,
	[AIR_GDS2] [dbo].[AIR_GDS] NULL,
	[ADT_QCHARGE] [money] NULL,
	[CHD_QCHARGE] [money] NULL,
	[INF_QCHARGE] [money] NULL,
	[CXL_REQ_YN] [char](1) NULL,
	[CXL_REQ_DATE] [datetime] NULL,
	[PRM_SEQ_NO] [int] NULL,
	[PAY_REQ_DATE] [datetime] NULL,
 CONSTRAINT [PK_RES_AIR_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_AIR_DETAIL] ADD  DEFAULT ((1)) FOR [FARE_SEAT_TYPE]
GO
ALTER TABLE [dbo].[RES_AIR_DETAIL] ADD  DEFAULT ((0)) FOR [NOR_PRICE]
GO
ALTER TABLE [dbo].[RES_AIR_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK__RES_AIR_D__RES_C__6EE06CCD] FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_AIR_DETAIL] CHECK CONSTRAINT [FK__RES_AIR_D__RES_C__6EE06CCD]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ?????????, 1 : ????????????, 2 : ????????????, 3 : ???????????????, 4 : ????????????, 5 : ????????????, 6 : ????????????, 9 : ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????GDS ( Topas : 1, (Abacus, Galileo, WorldSpan, Amadeus, ?????? = 9), AIRBUSAN = 100, AMADEUS?????? = 101, ABACUS?????? = 102, ????????? = 103, ????????? = 104)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ??????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PNR_CODE1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ??????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PNR_CODE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'OPEN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_FARE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'FARE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'CHD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'INF_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'TTL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'INTER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ADT_TAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'CHD_TAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'INF_TAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PNR_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PNR_MODIFY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AUTO_ISSUE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AUTO_ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AUTO_SUCC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'BKG_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : ?????????, 2 : ????????????, 3 : ?????????, 4 : ??????,  5 : ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'FARE_SEAT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????ID???' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'FARE_ID_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'FARE_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????ID??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ROUTE_ID_NBR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ROUTING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ( 0 : ??????, 1 : ??????, 2 : ?????????)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ROUTING_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'STAY_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'NOR_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'FARE_XML'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'RULE_XML'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????GDS2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_GDS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'ADT_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'CHD_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'INF_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'CXL_REQ_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'CXL_REQ_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PRM_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL', @level2type=N'COLUMN',@level2name=N'PAY_REQ_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_DETAIL'
GO
