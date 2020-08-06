import React, { FC } from 'react';
import { useField } from 'formik';

type Props = {
  label?: string;
  isDisabled?: boolean;
  name: string;
};

const InputText: FC<Props> = ({ label, isDisabled = false, name }: Props) => {
  const [field] = useField(name);

  return (
    <>
      <label>{label}</label>
      <input id={name} type="text" disabled={isDisabled} {...field} />
    </>
  );
};

export default InputText;
