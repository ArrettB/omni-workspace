
ALTER TABLE items
ADD CONSTRAINT [CHK_ITEM_BILLABLE_FLAG] CHECK (billable_flag = 'Y' OR billable_flag = 'N')
go

ALTER TABLE items
ADD CONSTRAINT [CHK_ITEM_ALLOW_EXPENSE_ENTRY] CHECK (allow_expense_entry = 'Y' OR allow_expense_entry = 'N')
go
