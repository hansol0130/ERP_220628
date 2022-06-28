USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ VIEW_NAME					: VIEW_SET_COMPLETE_2
■ DESCRIPTION				: 예약별 수익내역서 (2010년 2월 이후 출발일 기준)
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
									최초생성
================================================================================================================*/ 
CREATE VIEW [dbo].[VIEW_SET_COMPLETE_2] AS

	SELECT
		A.PRO_CODE, A.SET_STATE, ISNULL(dbo.FN_PRO_GET_TOTAL_PRICE(A.PRO_CODE), 0) AS SALE_PRICE, 
        ISNULL(dbo.FN_PRO_GET_PAY_PRICE(A.PRO_CODE), 0) AS PAY_PRICE, ISNULL(B_1.AIR_PROFIT, 0) AS AIR_PROFIT, ISNULL(B_1.AIR_PRICE, 0) AS AIR_PRICE,
		ISNULL(B_1.AIR_SALE_PRICE, 0) AS AIR_SALE_PRICE, ISNULL(C.LAND_COM_PRICE, 0) AS LAND_COM_PRICE, ISNULL(C.LAND_PRICE, 0) AS LAND_PRICE, 
		ISNULL(D.GROUP_PRICE, 0) AS GROUP_PRICE, ISNULL(D.GROUP_PROFIT, 0) AS GROUP_PROFIT, ISNULL(E.PERSON_PRICE, 0) AS PERSON_PRICE, 
		ISNULL(E.PERSON_PROFIT, 0) AS PERSON_PROFIT, ISNULL(E.PERSON_ETC_PRICE, 0) AS PERSON_ETC_PRICE, ISNULL(F.AGENT_COM_PRICE, 0) AS AGENT_COM_PRICE, 
		ISNULL(G.PAY_COM_PRICE, 0) AS PAY_COM_PRICE, ISNULL(H.AIR_ETC_PROFIT, 0) AS AIR_ETC_PROFIT, ISNULL(H.AIR_ETC_PRICE, 0) AS AIR_ETC_PRICE, 
		dbo.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS RES_COUNT, H.AIR_ETC_COM_PRICE, H.AIR_ETC_COM_PROFIT
	FROM dbo.SET_MASTER AS A WITH(NOLOCK)
	LEFT OUTER JOIN (
		-- 항공기 거래처별 고객
		SELECT
			PRO_CODE, SUM(ISNULL(COMM_PRICE, 0)) AS AIR_PROFIT, SUM(ISNULL(PAY_PRICE, 0)) AS AIR_PRICE, SUM(ISNULL(NET_PRICE, 0) + ISNULL(TAX_PRICE, 0)) AS AIR_SALE_PRICE
		FROM dbo.SET_AIR_CUSTOMER WITH(NOLOCK) 
		GROUP BY PRO_CODE
	) AS B_1 ON B_1.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 지상비 거래처
		SELECT
			PRO_CODE, SUM(ISNULL(COM_PRICE, 0)) AS LAND_COM_PRICE, SUM(ISNULL(PAY_PRICE, 0) + ISNULL(VAT_PRICE, 0)) AS LAND_PRICE
		FROM dbo.SET_LAND_AGENT WITH(NOLOCK) 
		GROUP BY PRO_CODE
	) AS C ON C.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 공동 경비
		SELECT
			PRO_CODE, SUM(CASE WHEN PROFIT_YN = 'N' THEN ISNULL(PRICE, 0) ELSE 0 END) AS GROUP_PRICE, SUM(CASE WHEN PROFIT_YN = 'Y' THEN ISNULL(PRICE, 0) ELSE 0 END) AS GROUP_PROFIT
		FROM dbo.SET_GROUP WITH(NOLOCK) 
		GROUP BY PRO_CODE
	) AS D ON D.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 개인 경비
		SELECT
			PRO_CODE, SUM(ISNULL(INS_PRICE, 0) + ISNULL(PASS_PRICE, 0) + ISNULL(VISA_PRICE, 0) + ISNULL(TAX_PRICE, 0)) AS PERSON_PRICE, 
			SUM(ISNULL(ETC_PROFIT, 0)) AS PERSON_PROFIT, SUM(ISNULL(ETC_PRICE, 0)) AS PERSON_ETC_PRICE
		FROM dbo.SET_CUSTOMER WITH(NOLOCK)
		GROUP BY PRO_CODE
	) AS E ON E.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		SELECT
			PRO_CODE, ISNULL(AGENT_COM_PRICE, 0) AS AGENT_COM_PRICE
		FROM (
			SELECT
				A.PRO_CODE, SUM(ISNULL(B.COMM_AMT, 0)) AS AGENT_COM_PRICE
			FROM dbo.RES_MASTER AS A WITH(NOLOCK)
			INNER JOIN dbo.RES_CUSTOMER AS B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
			WHERE (A.RES_STATE NOT IN (8, 9)) AND (B.RES_STATE IN (0, 3)) AND (A.SALE_COM_CODE IS NOT NULL)
			GROUP BY A.PRO_CODE
		) AS X
	) AS F ON F.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 입금내역
		SELECT B.PRO_CODE, SUM(ISNULL(A.COM_RATE * B.PART_PRICE * 0.01, 0)) AS PAY_COM_PRICE
		FROM dbo.PAY_MASTER_damo AS A WITH(NOLOCK)
		INNER JOIN dbo.PAY_MATCHING AS B WITH(NOLOCK) ON B.PAY_SEQ = A.PAY_SEQ
		WHERE (B.CXL_YN = 'N')
		GROUP BY B.PRO_CODE
	) AS G ON G.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 항공비 거래처
		SELECT
			PRO_CODE, SUM(ISNULL(AIR_ETC_PROFIT, 0)) AS AIR_ETC_PROFIT, SUM(ISNULL(AIR_ETC_PRICE, 0)) AS AIR_ETC_PRICE, 
            SUM(ISNULL(COMM_PRICE, 0)) AS AIR_ETC_COM_PRICE, SUM(ISNULL(COMM_PRICE, 0)) AS AIR_ETC_COM_PROFIT
		FROM dbo.SET_AIR_AGENT WITH(NOLOCK) 
		GROUP BY PRO_CODE
	) AS H ON H.PRO_CODE = A.PRO_CODE

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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B_1"
            Begin Extent = 
               Top = 6
               Left = 260
               Bottom = 114
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 207
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "D"
            Begin Extent = 
               Top = 114
               Left = 247
               Bottom = 207
               Right = 405
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "E"
            Begin Extent = 
               Top = 210
               Left = 38
               Bottom = 318
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 84
               Right = 640
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "H"
            Begin Extent = 
               Top = 318
               Left = 38
               Bottom = 426
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_SET_COMPLETE_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       Begin Table = "G"
            Begin Extent = 
               Top = 6
               Left = 678
               Bottom = 84
               Right = 842
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_SET_COMPLETE_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_SET_COMPLETE_2'
GO
