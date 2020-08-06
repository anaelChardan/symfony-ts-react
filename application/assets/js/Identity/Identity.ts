export type Identity = {
  id?: string;
  firstName: string;
  lastName: string;
  title: 'Mr' | 'Mme|Other';
};

export const defaultIdentity: Identity = {
  id: null,
  firstName: '',
  lastName: '',
  title: 'Mr',
};
