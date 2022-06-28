USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_GUIDE_DETAIL](
	[BOARD_SEQ] [int] NOT NULL,
	[COD_NO] [varchar](10) NOT NULL,
	[COD_CONTENTS] [varchar](200) NULL,
 CONSTRAINT [IDX_HBS_GUIDE_DETAIL] PRIMARY KEY CLUSTERED 
(
	[BOARD_SEQ] ASC,
	[COD_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HBS_GUIDE_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_340] FOREIGN KEY([BOARD_SEQ])
REFERENCES [dbo].[HBS_GUIDE] ([BOARD_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HBS_GUIDE_DETAIL] CHECK CONSTRAINT [R_340]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE_DETAIL', @level2type=N'COLUMN',@level2name=N'BOARD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE_DETAIL', @level2type=N'COLUMN',@level2name=N'COD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE_DETAIL', @level2type=N'COLUMN',@level2name=N'COD_CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드코멘트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE_DETAIL'
GO
