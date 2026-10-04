import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

export interface BodyHairCustomizer extends CustomizerChoice {
  material: string;
}

export const FeatureChoiceBodyHair = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { material } = choices as BodyHairCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Material">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'body_hair_material',
              })
            }
          >
            {material}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
