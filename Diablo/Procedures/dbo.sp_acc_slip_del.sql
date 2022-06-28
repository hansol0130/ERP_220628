USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: sp_acc_slip_del
■ DESCRIPTION				: 생성 전표 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2012-08-13		투어소프트		최초생성
   ...
   2020-11-25		김성호			단품상품 전표생성 로직 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[sp_acc_slip_del] 
	@slip_mk_day CHAR(8), 
	@slip_mk_seq SMALLINT, 
	@emp_no VARCHAR(10)
AS
	DECLARE @junl_fg          VARCHAR(2)
	       ,@send_yn          CHAR(1)
	       ,@del_day          CHAR(8)
	       ,@del_seq          SMALLINT
	       ,@del_cnt_002      SMALLINT
	       ,@pre_slip_cnt     SMALLINT
	       ,@stat             CHAR(1) 
	
	/* 전표Detail 자료 Delete */              
	
	SELECT @junl_fg = junl_fg
	FROM   acc_slipm
	WHERE  slip_mk_day = @slip_mk_day
	       AND slip_mk_seq = @slip_mk_seq              

	
	IF @junl_fg IS NOT NULL
	BEGIN
	    SELECT @stat = dbo.fn_docu_stat(@slip_mk_day ,@slip_mk_seq)              
	    
	    IF @stat IN ('F' ,'Y')
	        RETURN -7
	END
	
	IF @junl_fg = 'PR'
	BEGIN
	    SELECT @pre_slip_cnt = COUNT(*)
	    FROM   acc_pr_slip a
	    WHERE  a.slip_mk_day = @slip_mk_day
	           AND a.slip_mk_seq = @slip_mk_seq
	           AND EXISTS (
	                   SELECT b.pay_seq
	                   FROM   acc_re_slip b
	                         ,acc_slipm s
	                   WHERE  b.pay_seq = a.pay_seq
	                          AND b.slip_mk_day = s.slip_mk_day
	                          AND b.slip_mk_seq = s.slip_mk_seq
	                          AND s.junl_fg IN ('P1' ,'P2')
	               )
	    
	    IF @pre_slip_cnt > 0
	        RETURN -9
	END      
	
	SELECT @del_cnt_002 = COUNT(*)
	FROM   acc_slipd
	WHERE  slip_mk_day = @slip_mk_day
	       AND slip_mk_seq = @slip_mk_seq              
	
	DELETE 
	FROM   acc_slipd
	WHERE  slip_mk_day = @slip_mk_day
	       AND slip_mk_seq = @slip_mk_seq              
	
	DELETE 
	FROM   acc_slipm
	WHERE  slip_mk_day = @slip_mk_day
	       AND slip_mk_seq = @slip_mk_seq 
	
	-- DSR 전표 국외, 국내로 구분
	IF @junl_fg IN ('AI' ,'AK')
	BEGIN
	    DELETE 
	    FROM   acc_dsr_slip
	    WHERE  slip_mk_day = @slip_mk_day
	           AND slip_mk_seq = @slip_mk_seq
	END
	ELSE 
	IF @junl_fg IN ('RE' ,'ET')
	BEGIN
	    DELETE 
	    FROM   acc_re_slip
	    WHERE  slip_mk_day = @slip_mk_day
	           AND slip_mk_seq = @slip_mk_seq
	END
	ELSE 
	IF @junl_fg IN ('PR')
	BEGIN
	    DELETE 
	    FROM   acc_pr_slip
	    WHERE  slip_mk_day = @slip_mk_day
	           AND slip_mk_seq = @slip_mk_seq
	           AND NOT EXISTS (
	                   SELECT b.pay_seq
	                   FROM   acc_re_slip b
	                         ,acc_slipm s
	                   WHERE  b.pay_seq = acc_pr_slip.pay_seq
	                          AND b.slip_mk_day = s.slip_mk_day
	                          AND b.slip_mk_seq = s.slip_mk_seq
	                          AND s.junl_fg IN ('P1' ,'P2')
	               )
	END
	ELSE 
	IF @junl_fg IN ('P1' ,'P2')
	BEGIN
	    DELETE 
	    FROM   acc_re_slip
	    WHERE  slip_mk_day = @slip_mk_day
	           AND slip_mk_seq = @slip_mk_seq
	END
	ELSE 
	IF @junl_fg IN ('EV', 'PV')
	BEGIN
	    DELETE 
	    FROM   acc_ev_slip
	    WHERE  slip_mk_day = @slip_mk_day
	           AND slip_mk_seq = @slip_mk_seq
	END
	ELSE 
	IF SUBSTRING(@junl_fg ,1 ,1) = 'G'
	BEGIN
	    DELETE 
	    FROM   acc_pum_slip
	    WHERE  slip_mk_day = @slip_mk_day
	           AND slip_mk_seq = @slip_mk_seq
	END
GO
