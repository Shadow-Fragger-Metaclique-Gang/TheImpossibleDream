import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { ActionButton } from '../sexcon/ActionButton';
import { ProgressBars } from '../sexcon/ProgressBars';
import type { SexAction, SexSessionData } from './types';

// Color mapping for speed and force (matching old sexcon)
const levelColors = ['#eac8de', '#e9a8d1', '#f05ee1', '#d146f5', '#d61a43'];

type StepperProps = {
  value: number;
  max: number;
  names: string[];
  minWidth: string;
  onChange: (value: number) => void;
};

const Stepper = (props: StepperProps) => {
  const { value, max, names, minWidth, onChange } = props;
  return (
    <>
      <Button inline compact onClick={() => onChange(Math.max(1, value - 1))}>
        &lt;
      </Button>{' '}
      <Box
        as="span"
        bold
        style={{
          color: levelColors[value - 1],
          display: 'inline-block',
          minWidth: minWidth,
          textAlign: 'center',
        }}
      >
        {names[value - 1]}
      </Box>{' '}
      <Button inline compact onClick={() => onChange(Math.min(max, value + 1))}>
        &gt;
      </Button>
    </>
  );
};

export const SurrealisSexSession = () => {
  const { act, data } = useBackend<SexSessionData>();
  const [searchText, setSearchText] = useState('');
  const [arousalInput, setArousalInput] = useState('');

  // Split actions into two columns
  const filteredActions = data.actions.filter((action) =>
    action.name.toLowerCase().includes(searchText.toLowerCase()),
  );

  const leftColumn: SexAction[] = [];
  const rightColumn: SexAction[] = [];
  filteredActions.forEach((action, index) => {
    if (index % 2 === 0) {
      leftColumn.push(action);
    } else {
      rightColumn.push(action);
    }
  });

  const onClickActionButton = (actionType: string) => {
    if (data.current_action === actionType) {
      act('stop_action');
      return;
    }
    act('start_action', { action_type: actionType });
  };

  const submitArousal = () => {
    const amount = parseInt(arousalInput, 10);
    if (!Number.isNaN(amount)) {
      act('set_arousal_value', { amount });
      setArousalInput('');
    }
  };

  const renderColumn = (column: SexAction[]) => (
    <Stack vertical>
      {column.map((action) => (
        <Stack.Item key={action.type}>
          <Box textAlign="center">
            <ActionButton
              action={action}
              isCurrentAction={data.current_action === action.type}
              isAvailable={data.can_perform.includes(action.type)}
              onClick={() => onClickActionButton(action.type)}
            />
          </Box>
        </Stack.Item>
      ))}
    </Stack>
  );

  return (
    <Window title="Sate Desire" width={500} height={600}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Box textAlign="center" bold fontSize="1.1em">
              {data.title}
            </Box>
          </Stack.Item>

          <Stack.Item>
            <ProgressBars arousal={data.arousal} />
          </Stack.Item>
          <Divider />
          <Stack.Item>
            <Section>
              <Stack vertical>
                <Stack.Item>
                  <Box textAlign="center">
                    <Stepper
                      value={data.speed}
                      max={data.max_speed}
                      names={data.speed_names}
                      minWidth="110px"
                      onChange={(value) => act('set_speed', { value })}
                    />
                    {` -- | -- `}
                    <Stepper
                      value={data.force}
                      max={data.max_force}
                      names={data.force_names}
                      minWidth="90px"
                      onChange={(value) => act('set_force', { value })}
                    />
                  </Box>
                </Stack.Item>

                {!!data.has_penis && (
                  <Stack.Item>
                    <Box textAlign="center">
                      <Stepper
                        value={data.manual_arousal}
                        max={data.manual_arousal_names.length}
                        names={data.manual_arousal_names}
                        minWidth="130px"
                        onChange={(value) =>
                          act('set_manual_arousal', { value })
                        }
                      />
                    </Box>
                  </Stack.Item>
                )}

                {/* Finish Condition */}
                <Stack.Item>
                  <Box textAlign="center">
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => act('toggle_subtle')}
                    >
                      {data.doing_subtly ? 'DOING SUBTLY' : 'DOING VISIBLY'}
                    </Button>
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => act('toggle_finished')}
                    >
                      {data.do_until_finished
                        ? "UNTIL I'M FINISHED"
                        : 'UNTIL I STOP'}
                    </Button>
                    {' | '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => act('toggle_freeuse')}
                    >
                      {data.freeuse ? 'FREEUSE ON' : 'FREEUSE OFF'}
                    </Button>
                    {data.knot_mode === 'top' && (
                      <>
                        {' | '}
                        <Button
                          inline
                          compact
                          color="transparent"
                          onClick={() => act('toggle_knot')}
                        >
                          <Box
                            as="span"
                            bold
                            style={{
                              color: data.do_knot_action
                                ? '#d146f5'
                                : '#eac8de',
                            }}
                          >
                            {data.do_knot_action
                              ? 'USING KNOT'
                              : 'NOT USING KNOT'}
                          </Box>
                        </Button>
                      </>
                    )}
                    {data.knot_mode === 'bottom' && (
                      <>
                        {' | '}
                        <Button
                          inline
                          compact
                          color="transparent"
                          onClick={() => act('toggle_knot_bottom')}
                        >
                          <Box
                            as="span"
                            bold
                            style={{
                              color: data.do_knot_action_as_bottom
                                ? '#d146f5'
                                : '#eac8de',
                            }}
                          >
                            {data.do_knot_action_as_bottom
                              ? 'FORCING KNOT'
                              : 'NOT FORCING KNOT'}
                          </Box>
                        </Button>
                      </>
                    )}
                  </Box>
                </Stack.Item>

                <Stack.Item>
                  <Box textAlign="center">
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => act('toggle_bottom_exposed')}
                    >
                      {`${data.exposure_label} ${
                        data.bottom_exposed ? 'EXPOSED' : 'CONCEALED'
                      }`}
                    </Button>
                    {!!data.has_genitals && (
                      <>
                        {' | '}
                        <Button
                          inline
                          compact
                          color="transparent"
                          onClick={() => act('toggle_hide_pintle_visuals')}
                        >
                          {data.hide_pintle_visuals
                            ? 'GENITALS HIDDEN'
                            : 'GENITALS VISIBLE'}
                        </Button>
                      </>
                    )}
                  </Box>
                </Stack.Item>

                {/* Arousal Controls */}
                <Stack.Item>
                  <Box textAlign="center">
                    <Input
                      placeholder="Set arousal..."
                      value={arousalInput}
                      onChange={setArousalInput}
                      width="100px"
                      onEnter={submitArousal}
                    />{' '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      tooltip="Values above 120 cause immediate orgasm."
                      onClick={submitArousal}
                    >
                      SET
                    </Button>
                    {' | '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      disabled={!data.can_freeze}
                      onClick={() => act('freeze_arousal')}
                    >
                      {data.frozen ? 'UNFREEZE' : 'FREEZE'}
                    </Button>
                    {' | '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      disabled={!data.current_action}
                      onClick={() => act('stop_action')}
                    >
                      STOP
                    </Button>
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Divider />
          <Stack.Item>
            <Box textAlign="center" italic color="label">
              {data.doing_unto}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box textAlign="center">
              {data.categories.map((category, index) => (
                <span key={category.value}>
                  {index > 0 && ' | '}
                  <Button
                    inline
                    compact
                    color="transparent"
                    onClick={() =>
                      act('set_category', { value: category.value })
                    }
                  >
                    <Box
                      as="span"
                      bold={data.category === category.value}
                      style={{
                        color:
                          data.category === category.value
                            ? '#eac8de'
                            : undefined,
                      }}
                    >
                      {category.name}
                    </Box>
                  </Button>
                </span>
              ))}
            </Box>
          </Stack.Item>
          {/* Search */}
          <Stack.Item>
            <Stack>
              <Input
                fluid
                placeholder="Search for an interaction..."
                value={searchText}
                onChange={setSearchText}
              />
              <Button
                icon="sync"
                tooltip="Refresh"
                onClick={() => act('refresh')}
              />
            </Stack>
          </Stack.Item>
          {/* Two-Column Action Grid */}
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack fill>
                <Stack.Item basis="50%">{renderColumn(leftColumn)}</Stack.Item>
                <Stack.Item basis="50%">
                  {renderColumn(rightColumn)}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
