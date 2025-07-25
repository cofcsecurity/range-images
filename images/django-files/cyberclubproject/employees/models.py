# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Employee(models.Model):
    employeeid = models.AutoField(db_column='employeeID', primary_key=True)  # Field name made lowercase.
    fname = models.CharField(max_length=50)
    lname = models.CharField(max_length=50)
    position = models.CharField(max_length=50, blank=True, null=True)
    bank_account_number = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'employee'

    def __str__(self):
        return self.name
