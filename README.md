**Link to Project description
https://fetch-hiring.s3.amazonaws.com/analytics-engineer/ineeddata-data-modeling/data-modeling.html**

**Fetch Assessment**

**Tools and Technologies Used**:

- **PostgreSQL**: For querying and data storage.
- **Pyspark**: For extracting data from JSON to CSV.
- **Pandas and Numpy**: For further data manipulation and preparation.
- **Visio**: For generating the data model.

**Steps Involved to Solve the Challenge:**

**1\. Build the Data Model using Visio**

- **Files**: Saved in the folder "Data Model".
- **Behind the Scenes**:
  - Connecting **Users** and **Receipts**, and **Receipts** and **ReceiptItems** was straightforward.
  - Initially, I attempted to connect **Brands** and **ReceiptItems** on the **barcode** column, but found there were not many common values.
  - Further analysis revealed that **cpgId** from **Brands** and **pointsPayerId** from **ReceiptItems** had a fair number of common values.
  - Attempts to find common columns between **Users**/**Receipts** and **Brands** were unsuccessful.
  - Ultimately, I decided to join **ReceiptItems** and **Brands** on **pointsPayerId** and **cpgId**.

**2\. Extract the Data from JSON into CSV**

- **Files**: Code saved as "Fetch Rewards Data Transformation.ipynb" in the folder "Extracting data into CSV using Pyspark".
- **Behind the Scenes**:
  - During extraction, I found many rows in **ReceiptItems** with null or missing values.
  - To retain data integrity, I replaced these values with a default value of "-1".
  - This step focused on extracting data and handling missing values, without adjusting data types.

**3\. Clean the CSV Data Files and Prepare for Loading into PostgreSQL**

- **Files**: Code saved as "Cleaning CSV Files and Loading data into PostgreSQL" in the "Data Loading" folder.
- **Behind the Scenes**:
  - Adjusted data types and removed duplicates.
  - Identified **userId** values in **Receipts** without corresponding entries in **Users**.
  - Created a default user in **Users** and linked the orphaned **userId**s in **Receipts** to this default user.
  - Similarly, created a default brand in **Brands** for unmatched **pointsPayerId**s in **ReceiptItems**.
  - Maintained data integrity without deleting data, assuming future business inputs on handling these cases.

**4\. Load Data into PostgreSQL**

- **Files**: Queries saved in "Tables Creation" inside the "Data Loading" folder.

**5\. Solve Business Queries**

- **Files**: Queries saved in the "Queries" folder.
- **Behind the Scenes**:
  - Excluded default values created in earlier steps to ensure they do not affect query outcomes.

**6\. Perform Data Quality Checks**

- **Files**: Code saved in "Data Quality Validation Checks".
- **Behind the Scenes**:
  - Performed basic quality checks using Pandas on the extracted data.
  - Did not conduct deep data quality checks as this is an initial assessment.

**7\. Send Mail to the Business**

- **Files**: Mail content saved in "Mail to Business".
