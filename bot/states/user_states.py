from aiogram.fsm.state import State, StatesGroup


class UserPromoStates(StatesGroup):
    waiting_for_promo_code = State()


class UserDeviceLimitStates(StatesGroup):
    waiting_for_custom_device_limit = State()
