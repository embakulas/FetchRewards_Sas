CREATE TABLE users (
    _id VARCHAR PRIMARY KEY,
    state VARCHAR,
    createdDate TIMESTAMP WITH TIME ZONE,
    lastLogin TIMESTAMP WITH TIME ZONE,
    role VARCHAR,
    active BOOLEAN,
    signUpSource VARCHAR
);

CREATE TABLE receipts (
    _id VARCHAR PRIMARY KEY,
    user_id VARCHAR DEFAULT 'default_user_id',
    bonusPointsEarned INT,
    bonusPointsEarnedReason VARCHAR,
    createDate TIMESTAMP WITH TIME ZONE,
    dateScanned TIMESTAMP WITH TIME ZONE,
    finishedDate TIMESTAMP WITH TIME ZONE,
    modifyDate TIMESTAMP WITH TIME ZONE,
    pointsAwardedDate TIMESTAMP WITH TIME ZONE,
    pointsEarned FLOAT,
    purchaseDate TIMESTAMP WITH TIME ZONE,
    purchasedItemCount INT,
    rewardsReceiptStatus VARCHAR,
    totalSpent FLOAT,
    CONSTRAINT fk_user
        FOREIGN KEY(user_id) 
        REFERENCES users(_id)
        ON UPDATE CASCADE
        ON DELETE SET DEFAULT
);

CREATE TABLE brands (
    _id VARCHAR PRIMARY KEY,
    barcode VARCHAR,
    brandCode VARCHAR,
    category VARCHAR,
    categoryCode VARCHAR,
    name VARCHAR,
    topBrand BOOLEAN,
    cpgId VARCHAR,
    cpgRef VARCHAR
);

CREATE TABLE receiptItems (
    receipt_item_id SERIAL PRIMARY KEY,  -- Auto-generated ID for each receipt item
    receipt_id VARCHAR,  -- FOREIGN KEY to receipts table
    barcode VARCHAR,
    description VARCHAR,
    finalPrice FLOAT,
    itemPrice FLOAT,
    needsFetchReview BOOLEAN,
    partnerItemId VARCHAR,
    preventTargetGapPoints BOOLEAN,
    quantityPurchased INT,
    userFlaggedBarcode VARCHAR,
    userFlaggedNewItem BOOLEAN,
    userFlaggedPrice FLOAT,
    userFlaggedQuantity INT,
    needsFetchReviewReason VARCHAR,
    pointsNotAwardedReason VARCHAR,
    pointsPayerId VARCHAR,
    rewardsGroup VARCHAR,
    rewardsProductPartnerId VARCHAR,
    userFlaggedDescription VARCHAR,
    FOREIGN KEY (receipt_id) REFERENCES receipts(_id) ON DELETE CASCADE  -- Ensures integrity with receipts table
);

CREATE TABLE receipt_items_brands_mapping (
    mapping_id SERIAL PRIMARY KEY,
    receipt_item_id INT,
    _id VARCHAR,
    FOREIGN KEY (receipt_item_id) REFERENCES receiptItems(receipt_item_id) ON DELETE CASCADE,
    FOREIGN KEY (_id) REFERENCES brands(_id) ON DELETE CASCADE
);

INSERT INTO receipt_items_brands_mapping (receipt_item_id, _id)
SELECT ri.receipt_item_id, b._id
FROM receiptItems ri
JOIN brands b ON ri.pointsPayerId = b.cpgId;

select * from receipt_items_brands_mapping;


