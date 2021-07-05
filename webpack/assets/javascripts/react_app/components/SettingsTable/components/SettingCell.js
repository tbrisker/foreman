import React from 'react';
import PropTypes from 'prop-types';

import { sprintf, translate as __ } from '../../../common/I18n';

import { withTooltip, defaultToString } from '../SettingsTableHelpers';

import SettingCellInner from './SettingCellInner';

import './SettingCell.scss';

const SettingCell = ({ setting, className }) => {
  const fieldProps = {
    setting,
    tooltipId: setting.name,
    className,
  };

  if (setting.readonly) {
    fieldProps.tooltipText = sprintf(
      __(
        'This setting is defined in the configuration file %s and is read-only.'
      ),
      setting.configFile
    );
  } else {
    const defaultStr = defaultToString(setting);
    fieldProps.tooltipText = sprintf(__('Default: %s'), defaultStr);
  }

  const Component = withTooltip(SettingCellInner);
  return <Component {...fieldProps} />;
};

SettingCell.propTypes = {
  setting: PropTypes.object.isRequired,
  className: PropTypes.string,
};

SettingCell.defaultProps = {
  className: '',
};

export default SettingCell;
