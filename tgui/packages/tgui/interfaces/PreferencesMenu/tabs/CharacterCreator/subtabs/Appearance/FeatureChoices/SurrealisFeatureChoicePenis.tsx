import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export interface SurrealisPenisCustomizer extends CustomizerChoice {
  penis_size: string;
  penis_functional: BooleanLike;
  sheath_type: string;
  can_be_massive: BooleanLike;
  penis_massive: BooleanLike;
}
export const SurrealisFeatureChoicePenis = (props: {
  customizer: Customizer;
}) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const {
    penis_size,
    penis_functional,
    sheath_type,
    can_be_massive,
    penis_massive,
  } = choices as SurrealisPenisCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Penis Size">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'penis_size',
              })
            }
          >
            {penis_size}
          </Button>
        </LabeledGridList.Item>
        {!!can_be_massive && (
          <LabeledGridList.Item
            label="MASSIVE (10 TRI)"
            tooltip="This will make your pintle MASSIVE. Even a gentle touch will be felt, and rough treatment may seriously harm your partners. Arousal may induce symptoms of blood loss as your body struggles to fuel your inhumen erection."
          >
            <Button.Checkbox
              checked={!!penis_massive}
              selected={!!penis_massive}
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'massive',
                })
              }
            />
          </LabeledGridList.Item>
        )}
        <LabeledGridList.Item label="Functional">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'functional',
              })
            }
          >
            {penis_functional ? 'YES' : 'NO'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Sheath">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'sheath_type',
              })
            }
          >
            {sheath_type}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
