Create database library_management;
Use library_management
select * from Books;
-- Find All Books Borrowed by a Specific User.
SELECT 
    b.Title, b.Author, t.BorrowDate, t.ReturnDate, t.Status
FROM 
    Transactions t
JOIN 
    Books b ON t.BookID = b.BookID
WHERE 
    t.UserID = 1;
    -- Find Overdue Books.
SELECT 
    b.Title, u.FirstName, u.LastName, t.BorrowDate
FROM 
    Transactions t
JOIN 
    Books b ON t.BookID = b.BookID
JOIN 
    Users u ON t.UserID = u.UserID
WHERE 
    t.Status = 'Borrowed' AND t.BorrowDate < CURDATE() - INTERVAL 14 DAY;
    --  Find the Most Popular Books.
SELECT 
    b.Title, COUNT(t.TransactionID) AS BorrowCount
FROM 
    Transactions t
JOIN 
    Books b ON t.BookID = b.BookID
GROUP BY 
    b.BookID
ORDER BY 
    BorrowCount DESC;
    DELIMITER //
CREATE PROCEDURE BorrowBook(IN p_UserID INT, IN p_BookID INT)
BEGIN
    DECLARE bookAvailable INT;
    
    -- Check if the book is available
    SELECT COUNT(*) INTO bookAvailable 
    FROM Transactions 
    WHERE BookID = p_BookID AND Status = 'Borrowed';
    
    IF bookAvailable = 0 THEN
        -- Borrow the book
        INSERT INTO Transactions (BookID, UserID, BorrowDate, Status)
        VALUES (p_BookID, p_UserID, CURDATE(), 'Borrowed');
        SELECT 'Book borrowed successfully';
    ELSE
        SELECT 'Book is already borrowed';
    END IF;
END //
DELIMITER ;

CALL BorrowBook(1, 3);

CREATE INDEX idx_isbn ON Books (ISBN);
CREATE INDEX idx_email ON Users (Email);