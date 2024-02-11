import { application } from "./application"

import Select from './select_controller'
application.register('select', Select)

import DisapproveModal from './disapprove_modal_controller'
application.register('disapprove-modal', DisapproveModal)

import HistoryModal from './history_modal_controller'
application.register('history-modal', HistoryModal)
