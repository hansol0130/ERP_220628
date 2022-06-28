USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAX_MASTER](
	[FAX_SEQ] [char](17) NOT NULL,
	[FAX_TYPE] [char](1) NULL,
	[SEND_TYPE] [char](1) NULL,
	[SUBJECT] [varchar](100) NULL,
	[CONTENTS] [nvarchar](max) NULL,
	[REMARK] [varchar](100) NULL,
	[SEND_NUMBER1] [varchar](4) NULL,
	[SEND_NUMBER2] [varchar](4) NULL,
	[SEND_NUMBER3] [varchar](4) NULL,
	[RESERVE_DATE] [datetime] NULL,
	[RESERVE_YN] [char](1) NULL,
	[PAGE_COUNT] [int] NULL,
	[READ_YN] [char](1) NULL,
	[DEL_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[FAX_GROUP] [int] NULL,
	[FAX_CAT_SEQ] [dbo].[SEQ_NO] NULL,
 CONSTRAINT [PK_FAX_MASTER] PRIMARY KEY CLUSTERED 
(
	[FAX_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'SEND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'SEND_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'SEND_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'SEND_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'RESERVE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'RESERVE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'페이지수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'PAGE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'읽음유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'READ_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_GROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_CAT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_MASTER'
GO
