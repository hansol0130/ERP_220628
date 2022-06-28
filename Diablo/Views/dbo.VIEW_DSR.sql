USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_DSR]
AS
SELECT     ISSUE_DATE, AIRLINE_CODE, PRO_CODE, REQUEST_CODE, ISSUE_CODE, SALE_CODE, GDS, COMPANY, TICKET_START, TICKET_END, TICKET_COUNT, 
                      VOID_COUNT, REFUND_COUNT, MATCHING_YN, FARE, TAX_PRICE, DISCOUNT, NET_PRICE, CARD_PRICE, CASH_PRICE, COMM_PRICE, CARD_NUM,
                          (SELECT     KOR_NAME
                            FROM          dbo.EMP_MASTER WITH (NOLOCK)
                            WHERE      (EMP_CODE = X.ISSUE_CODE)) AS ISSUE_NAME,
                          (SELECT     KOR_NAME
                            FROM          dbo.EMP_MASTER AS EMP_MASTER_1 WITH (NOLOCK)
                            WHERE      (EMP_CODE = X.SALE_CODE)) AS SALE_NAME
FROM         (SELECT     A.ISSUE_DATE, A.AIRLINE_CODE, A.PRO_CODE, A.REQUEST_CODE, A.ISSUE_CODE, A.SALE_CODE, A.GDS, A.COMPANY, A.CARD_NUM, MIN(A.TICKET) 
                                              AS TICKET_START, MAX(A.TICKET) AS TICKET_END, SUM(CASE TICKET_STATUS WHEN 1 THEN 1 ELSE 0 END) AS TICKET_COUNT, SUM(A.FARE) AS FARE, 
                                              SUM(A.TAX_PRICE) AS TAX_PRICE, SUM(A.DISCOUNT) AS DISCOUNT, SUM(A.NET_PRICE) AS NET_PRICE, SUM(ISNULL(A.CARD_PRICE, 0)) 
                                              AS CARD_PRICE, SUM(ISNULL(A.CASH_PRICE, 0)) AS CASH_PRICE, SUM(A.COMM_PRICE) AS COMM_PRICE, 
                                              SUM(CASE TICKET_STATUS WHEN 2 THEN 1 ELSE 0 END) AS VOID_COUNT, SUM(CASE WHEN B.TICKET IS NULL THEN 0 ELSE 1 END) 
                                              AS REFUND_COUNT, MIN(CASE WHEN PRO_CODE IS NULL OR
                                              RES_CODE IS NULL OR
                                              RES_SEQ_NO = 0 THEN 'N' ELSE 'Y' END) AS MATCHING_YN
                       FROM          dbo.DSR_TICKET AS A WITH (NOLOCK) LEFT OUTER JOIN
                                              dbo.DSR_REFUND AS B WITH (NOLOCK) ON B.TICKET = A.TICKET
                       GROUP BY A.ISSUE_DATE, A.AIRLINE_CODE, A.PRO_CODE, A.REQUEST_CODE, A.ISSUE_CODE, A.SALE_CODE, A.GDS, A.COMPANY, A.CARD_NUM) AS X
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = -1141
      End
      Begin Tables = 
         Begin Table = "X"
            Begin Extent = 
               Top = 198
               Left = 1179
               Bottom = 317
               Right = 1349
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_DSR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_DSR'
GO
