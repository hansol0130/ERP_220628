USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 핸드폰번호 잘라오기
CREATE function [dbo].[FN_PHONE_SUBSTRING]
(
	@phone varchar(15),
	@seq int 
)
returns varchar(10)
as
begin

	declare @number varchar(10)

	if @phone is not null
	begin
		declare @temp varchar(15), @f int, @word1 varchar(5), @word2 varchar(5), @word3 varchar(5)

		set @temp = ltrim(rtrim(@phone))

		set @f = patindex('%-%', @temp)
		if @f > 0
		begin
			set @word1 = substring(@temp, 1, @f-1)
			set @temp = substring(@temp, @f+1, 15)
			set @f = patindex('%-%', @temp)

			if @f > 0
			begin
				set @word2 = substring(@temp, 1, @f-1)
				set @word3 = substring(@temp, @f+1, 15)

				set @number = case @seq
								when 1 then @word1
								when 2 then @word2
								when 3 then @word3 end
			end
		end
	end

	return @number
end
GO
