import type { ReactElement, ReactNode } from 'react'
import { Button } from '@mui/material'
import useSafeInfo from '@/hooks/useSafeInfo'
import PagePlaceholder from '../PagePlaceholder'
import { AppRoutes } from '@/config/routes'
import Link from 'next/link'

const SafeLoadingError = ({ children }: { children: ReactNode }): ReactElement => {
  const { safeError } = useSafeInfo()

  if (!safeError) return <>{children}</>

  return (
    <PagePlaceholder
      img={<img src="/images/common/error.png" alt="A vault with a red icon in the bottom right corner" />}
      text="This Safe Account couldn't be loaded"
    >
      <Link href={AppRoutes.welcome.index}>
        {/* @next-codemod-error This Link previously used the now removed `legacyBehavior` prop, and has a child that might not be an anchor. The codemod bailed out of lifting the child props to the Link. Check that the child component does not render an anchor, and potentially move the props manually to Link. */
        }
        <Button variant="contained" color="primary" size="large" sx={{ mt: 2 }}>
          Go to the main page
        </Button>
      </Link>
    </PagePlaceholder>
  );
}

export default SafeLoadingError
