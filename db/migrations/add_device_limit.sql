-- Migration: Add device_limit field to payments and subscriptions tables

-- Add device_limit column to payments table
ALTER TABLE payments ADD COLUMN device_limit INTEGER DEFAULT 1;

-- Add device_limit column to subscriptions table
ALTER TABLE subscriptions ADD COLUMN device_limit INTEGER DEFAULT 1;

-- Add comments for documentation
COMMENT ON COLUMN payments.device_limit IS 'Number of devices for this subscription';
COMMENT ON COLUMN subscriptions.device_limit IS 'Number of devices for this subscription';
