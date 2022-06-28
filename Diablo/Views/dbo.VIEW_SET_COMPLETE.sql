USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ VIEW_NAME					: VIEW_SET_COMPLETE
■ DESCRIPTION				: 정산데이터 조회
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
									최초생성
2016-03-28			김성호			도착일 추가
2016-08-08			김성호			대리점 수수료 계산 시 판매처 체크 삭제
2019-07-24			김성호			정산마감자 정보 추가
2019-09-16			김성호			대리점 수수료 예외처리 (네이버 PROVIDER=41 판매가 기준)
2022-05-11			김성호			온라인팀 정산기준 변경(출발일->발권일)으로 출발일 위치 변경 (SET_MASTER.DEP_DATE -> PKG_DETAIL.DEP_DATE)
================================================================================================================*/ 
CREATE VIEW [dbo].[VIEW_SET_COMPLETE] AS

	SELECT
		A.PRO_CODE, A.SET_STATE, ISNULL(dbo.FN_PRO_GET_TOTAL_PRICE(A.PRO_CODE), 0) AS SALE_PRICE, 
		ISNULL(dbo.FN_PRO_GET_PAY_PRICE(A.PRO_CODE), 0) AS PAY_PRICE, ISNULL(B_1.AIR_PROFIT, 0) AS AIR_PROFIT, ISNULL(B_1.AIR_PRICE, 0) AS AIR_PRICE, 
		ISNULL(B_1.AIR_SALE_PRICE, 0) AS AIR_SALE_PRICE, ISNULL(C.LAND_COM_PRICE, 0) AS LAND_COM_PRICE, 
		ISNULL(C.LAND_PRICE, 0) AS LAND_PRICE, ISNULL(D.GROUP_PRICE, 0) AS GROUP_PRICE, ISNULL(D.GROUP_PROFIT, 0) AS GROUP_PROFIT, 
		ISNULL(E.PERSON_PRICE, 0) AS PERSON_PRICE, ISNULL(E.PERSON_PROFIT, 0) AS PERSON_PROFIT, ISNULL(E.PERSON_ETC_PRICE, 0) AS PERSON_ETC_PRICE, 
		ISNULL(F.AGENT_COM_PRICE, 0) AS AGENT_COM_PRICE, ISNULL(G.PAY_COM_PRICE, 0) AS PAY_COM_PRICE, 
		ISNULL(H.AIR_ETC_PROFIT, 0) AS AIR_ETC_PROFIT, ISNULL(H.AIR_ETC_PRICE, 0) AS AIR_ETC_PRICE, dbo.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS RES_COUNT, 
		H.AIR_ETC_COM_PRICE, H.AIR_ETC_COM_PROFIT, A.PROFIT_TEAM_CODE, A.PROFIT_TEAM_NAME, PD.DEP_DATE, A.ARR_DATE, A.CLOSE_CODE, A.CLOSE_DATE
	FROM dbo.SET_MASTER AS A WITH (NOLOCK)
	INNER JOIN dbo.PKG_DETAIL PD WITH(NOLOCK) ON A.PRO_CODE = PD.PRO_CODE
	LEFT OUTER JOIN (
		-- 항공기 거래처별 고객
		SELECT
			PRO_CODE, SUM(ISNULL(COMM_PRICE, 0)) AS AIR_PROFIT, SUM(ISNULL(PAY_PRICE, 0)) AS AIR_PRICE, SUM(ISNULL(NET_PRICE, 0) + ISNULL(TAX_PRICE, 0)) AS AIR_SALE_PRICE
		FROM dbo.SET_AIR_CUSTOMER WITH (NOLOCK)
		GROUP BY PRO_CODE
	) AS B_1 ON B_1.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 지상비 거래처
		SELECT
			PRO_CODE, SUM(ISNULL(COM_PRICE, 0)) AS LAND_COM_PRICE, SUM(ISNULL(PAY_PRICE, 0) + ISNULL(VAT_PRICE, 0)) AS LAND_PRICE
		FROM dbo.SET_LAND_AGENT WITH (NOLOCK)
		GROUP BY PRO_CODE
	) AS C ON C.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 공동 경비
		SELECT
			PRO_CODE, SUM(CASE WHEN PROFIT_YN = 'N' THEN ISNULL(PRICE, 0) ELSE 0 END) AS GROUP_PRICE, 
			SUM(CASE WHEN PROFIT_YN = 'Y' THEN ISNULL(PRICE, 0) ELSE 0 END) AS GROUP_PROFIT
		FROM dbo.SET_GROUP WITH (NOLOCK)
		GROUP BY PRO_CODE
	) AS D ON D.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 개인 경비
		SELECT
			PRO_CODE, SUM(ISNULL(INS_PRICE, 0) + ISNULL(PASS_PRICE, 0) + ISNULL(VISA_PRICE, 0) + ISNULL(TAX_PRICE, 0)) AS PERSON_PRICE, 
			SUM(ISNULL(ETC_PROFIT, 0)) AS PERSON_PROFIT, SUM(ISNULL(ETC_PRICE, 0)) AS PERSON_ETC_PRICE
		FROM dbo.SET_CUSTOMER WITH (NOLOCK)
	GROUP BY PRO_CODE
	) AS E ON E.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
	
		SELECT
			PRO_CODE, ISNULL(AGENT_COM_PRICE, 0) AS AGENT_COM_PRICE
		FROM (
			SELECT
				PRO_CODE, SUM(
					CASE
						WHEN COMM_RATE = 0 THEN ISNULL(COMM_AMT, 0) 
						ELSE ISNULL(COMM_RATE, 0) * 0.01 * (
							-- 네이버 대리점 수수료 예외처리
							CASE
								WHEN PROVIDER = 41 THEN ISNULL(dbo.FN_RES_GET_TOTAL_PRICE(RES_CODE), 0)
								ELSE ISNULL(dbo.FN_RES_GET_SALE_PRICE(RES_CODE), 0)
							END)
					END) AS AGENT_COM_PRICE
			FROM dbo.RES_MASTER_DAMO WITH (NOLOCK)
			WHERE (RES_STATE NOT IN (8, 9)) --AND (SALE_COM_CODE IS NOT NULL)
			GROUP BY PRO_CODE

		) AS X
	) AS F ON F.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 입금내역
		SELECT
			B.PRO_CODE, SUM(CASE WHEN A.COM_RATE = 0 AND A.COM_PRICE <> 0 AND A.PAY_TYPE = 12 THEN A.COM_PRICE ELSE ISNULL(ISNULL(A.COM_RATE, 0) * ISNULL(B.PART_PRICE, 0) * 0.01, 0) END) AS PAY_COM_PRICE
		FROM dbo.PAY_MASTER_damo AS A WITH (NOLOCK)
		INNER JOIN dbo.PAY_MATCHING AS B WITH (NOLOCK) ON B.PAY_SEQ = A.PAY_SEQ
		WHERE (B.CXL_YN = 'N')
		GROUP BY B.PRO_CODE
	) AS G ON G.PRO_CODE = A.PRO_CODE
	LEFT OUTER JOIN (
		-- 항공비 거래처
		SELECT
			PRO_CODE, SUM(ISNULL(AIR_ETC_PROFIT, 0)) AS AIR_ETC_PROFIT, SUM(ISNULL(AIR_ETC_PRICE, 0)) AS AIR_ETC_PRICE, 
			SUM(CASE WHEN COM_RATE > 0 THEN - 1 * ISNULL(COM_RATE, 0) * 0.01 * ISNULL(AIR_ETC_PRICE, 0) ELSE ISNULL(CASE WHEN COMM_PRICE < 0 THEN COMM_PRICE ELSE 0 END, 0) END) AS AIR_ETC_COM_PRICE, 
			SUM(CASE WHEN COM_RATE > 0 THEN ISNULL(COM_RATE, 0) * 0.01 * ISNULL(AIR_ETC_PROFIT, 0) ELSE ISNULL(CASE WHEN COMM_PRICE > 0 THEN COMM_PRICE ELSE 0 END, 0) END) AS AIR_ETC_COM_PROFIT
		FROM dbo.SET_AIR_AGENT WITH (NOLOCK)
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
         Configuration = "(H (1[50] 2[25] 3) )"
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
         Configuration = "(H (2[71] 3) )"
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
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
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
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B_1"
            Begin Extent = 
               Top = 102
               Left = 449
               Bottom = 210
               Right = 613
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 230
               Bottom = 99
               Right = 401
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "D"
            Begin Extent = 
               Top = 6
               Left = 439
               Bottom = 99
               Right = 597
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "E"
            Begin Extent = 
               Top = 102
               Left = 230
               Bottom = 210
               Right = 411
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent = 
               Top = 6
               Left = 635
               Bottom = 84
               Right = 813
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "H"
            Begin Extent = 
               Top = 162
               Left = 651
               Bottom = 270
               Right = 846
            End
            DisplayFlags = 280
            TopColumn = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_SET_COMPLETE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'0
         End
         Begin Table = "G"
            Begin Extent = 
               Top = 84
               Left = 651
               Bottom = 162
               Right = 815
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
      PaneHidden = 
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_SET_COMPLETE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_SET_COMPLETE'
GO
