
USE [master]
GO
IF DB_ID('PartitionDB') IS NOT NULL
BEGIN
	ALTER DATABASE [PartitionDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [PartitionDB]
END
GO
CREATE DATABASE [PartitionDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PartitionDB', FILENAME = N'/var/opt/mssql/data/PartitionDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [SalesOrders_DataPartition1] 
( NAME = N'SalesOrders_DataPartition1', FILENAME = N'/var/opt/mssql/data/SalesOrders_DataPartition1.ndf' , SIZE = 10240KB , MAXSIZE = 122880KB , FILEGROWTH = 10240KB ), 
 FILEGROUP [SalesOrders_DataPartition2] 
( NAME = N'SalesOrders_DataPartition2', FILENAME = N'/var/opt/mssql/data/SalesOrders_DataPartition2.ndf' , SIZE = 10240KB , MAXSIZE = 122880KB , FILEGROWTH = 10240KB ), 
 FILEGROUP [SalesOrders_DataPartition3] 
( NAME = N'SalesOrders_DataPartition3', FILENAME = N'/var/opt/mssql/data/SalesOrders_DataPartition3.ndf' , SIZE = 10240KB , MAXSIZE = 122880KB , FILEGROWTH = 10240KB ), 
 FILEGROUP [SalesOrders_DataPartition4] 
( NAME = N'SalesOrders_DataPartition4', FILENAME = N'/var/opt/mssql/data/SalesOrders_DataPartition4.ndf' , SIZE = 10240KB , MAXSIZE = 122880KB , FILEGROWTH = 10240KB ), 
 FILEGROUP [SalesOrders_DataPartition5] 
( NAME = N'SalesOrders_DataPartition5', FILENAME = N'/var/opt/mssql/data/SalesOrders_DataPartition5.ndf' , SIZE = 20480KB , MAXSIZE = 122880KB , FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'PartitionDB_log', FILENAME = N'/var/opt/mssql/log/PartitionDB_log.ldf' , SIZE = 67968KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

