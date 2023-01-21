use anchor_lang::prelude::*;
use crate::Increment;

pub fn ix(ctx: Context<Increment>) -> Result<()> {
    let user = &mut ctx.accounts.user;
    user.increment += 1;
    Ok(())
}
